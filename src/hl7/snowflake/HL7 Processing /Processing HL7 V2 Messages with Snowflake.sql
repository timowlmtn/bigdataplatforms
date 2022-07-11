/*****************************************************************************************

██╗  ██╗██╗  ███████╗
██║  ██║██║  ╚════██║
███████║██║      ██╔╝
██╔══██║██║     ██╔╝ 
██║  ██║███████╗██║  
╚═╝  ╚═╝╚══════╝╚═╝  
                     
HL7 is the universal healthcare IT language spoken by the majority of Providers. 
Capability to ingest and parse HL7 into Snowflake opens the door for wide range of 
use cases:

Clinical
    ○ Clinical Quality Measurement
    ○ Care Delivery Efficiency Analytics
    ○ Health Outcomes Analytics
Accountable Care
    ○ Population Health
    ○ Patient 360 Analytics
    ○ Value based Payment Modelling
Research & Development
    ○ Clinical Trials Management
    ○ Clinical Data Registries
Operational
    ○ Revenue Cycle Optimization
    ○ Facility and Resource Utilization Analytics
Consumer
    ○ Patient Satisfaction
    ○ Marketing Analytics
    
... and more!
*****************************************************************************************/


/*****************************************************************************************
-- Setup a database and a virtual warehouse (compute cluster)
-- TIP #1: In Snowflake, you can do all of this with simple SQL commands!
-- TIP #2: In Snowflake, ANY warehouse can query ANY database
*****************************************************************************************/
USE ROLE SYSADMIN;
CREATE DATABASE HL7;
CREATE WAREHOUSE HL7_WH WAREHOUSE_SIZE = 'SMALL';
CREATE SCHEMA HL7V2DEMO;

/*****************************************************************************************
-- Navigate to our database and schema
*****************************************************************************************/
USE DATABASE HL7;
USE SCHEMA HL7V2DEMO;
USE WAREHOUSE HL7_WH;

/*****************************************************************************************
-- Create and external stage for access to files stored on s3
TIP: In Snowflake users can securely work with files stored externally in object storage
*****************************************************************************************/
CREATE OR REPLACE STAGE STG_HL7DATA URL='s3://sf-hcls-meacham/'
storage_integration = s3_int
directory = ( enable = true );

-- refresh directory to capture metadata
ALTER STAGE STG_HL7DATA REFRESH;

/*****************************************************************************************
-- list contents of external stage
TIP: Snowflake can query, store, and process ALL data, including unstructured
*****************************************************************************************/
LIST @STG_HL7DATA;

-- view directory table
select 
    s.* 
    , get_presigned_url(@stg_hl7data, s.RELATIVE_PATH, 3600) as download
from directory( @stg_hl7data ) s;



/*****************************************************************************************
-- Create Java UDTF, UDF, and Python UDF
-- TIP: In Snowflake you can go BEYOND SQL, with custom JAVA and PYTHON functions!

DID YOU KNOW?
Snowflake gives you the ability to leverage "off the self" open source Java and 
Python packages directly in Snowflake to accelerate your projects.
-Java: HAPI
--https:--hapifhir.github.io/hapi-hl7v2/
-Python: HL7apy
--https:--crs4.github.io/hl7apy/
*****************************************************************************************/


/******************************************************************************************
-- Create JAVA UDTF 
*****************************************************************************************/
create or replace function hl7_hapi_parser(hl7_fl_url varchar ,validate_message boolean)
    RETURNS TABLE ( 
        parsed_status boolean, 
        raw_msg varchar, 
        hl7_xml varchar,  
        hl7_json variant,  
        message_type varchar, 
        message_version varchar, 
        message_sequence_num integer, 
        error_msg varchar 
    )
  language JAVA
imports= ('@stg_hl7data/javafn_external_stage/sf-hl7v2-parser-1.0-SNAPSHOT-jar-with-dependencies.jar')
  handler = 'com.snowflake.labs.hl7.HL7UDTF';

/*****************************************************************************************
-- Create JAVA UDF ☕
*****************************************************************************************/
create or replace function hl7_hapi_udf_parser(hl7_msg varchar ,validate_message boolean)
returns variant
language java
imports = ('@stg_hl7data/javafn_external_stage/sf-hl7v2-parser-1.0-SNAPSHOT-jar-with-dependencies.jar')
handler = 'com.snowflake.labs.hl7.HL7UDF.process';

/*****************************************************************************************
-- Create Python UDF 🐍
*****************************************************************************************/
create or replace function hl7pyparser(hl7_raw string)
returns variant
language python
runtime_version = 3.8
imports=('@stg_hl7data/pyfn_lib/hl7apy-1.3.4.zip', '@stg_hl7data/pyfn_lib/hl7pyparserUDF.py')
handler = 'hl7pyparserUDF.udf'
comment = 'python based hl7v2 message parser';


/*****************************************************************************************
-- Show available functions
*****************************************************************************************/
SHOW USER FUNCTIONS;

/*****************************************************************************************
-- Using the Java UDTF parse the HL7 messages in the files present in the 
   AWS external stage.
*****************************************************************************************/
with base as (
    select 
        relative_path as data_filepath,
        concat('@stg_hl7data/' ,data_filepath) as full_path
    from directory( @stg_hl7data )
    where relative_path like 'datasets/hl7/%'
)
select 
    full_path, p.* 
from base as b,
table(hl7_hapi_parser(b.full_path, false) ) as p;

/*****************************************************************************************
-- Using the Java UDTF parse the HL7 messages in the files and load the data to a raw table 
-- TIP: Snowflake can store and query semi-structured data natively
-- What are the codes? https://hl7-definition.caristix.com/v2/HL7v2.5.1/DataTypes
*****************************************************************************************/
create or replace table raw as 
  select * from (
  with base as (
      select 
          relative_path as data_filepath,
          concat('@stg_hl7data/' ,data_filepath) as full_path
      from directory( @stg_hl7data )
      where relative_path like 'datasets/hl7/%'
           --and full_path like'%sample_2.txt'
  )
  select 
      full_path, p.* 
  from base as b
      ,table(hl7_hapi_parser(b.full_path, false) ) as p);

/*****************************************************************************************
-- Query the data in the RAW table and the parsed Hl7 message types
-- How many HL7 messages are there?
*****************************************************************************************/
select count(*) from raw;

/*****************************************************************************************
-- What does the data look like?
*****************************************************************************************/
select * from raw;

/*****************************************************************************************
-- How many unstructured files did these records come from?
*****************************************************************************************/
select distinct full_path from raw;


/*****************************************************************************************
-- Query the OBSERVATION segment (OBR) fields.
-- You can use this query to load a database table such as OMOP’s Observation table.
*****************************************************************************************/
-- Flatten the JSON Field to pull OBSERVATION (OBR) segment fields
with base as (
    select hl7_json as msg
    from raw
  where message_sequence_num=1 and message_type='ORU_R01'
), oru_response_sgmt as (
    select 
        msg:"ORU_R01.RESPONSE" as oru_response
    from base
)
 select
    oru_response,
    oru_response:"ORU_R01.ORDER_OBSERVATION":"OBR":"OBR.4" as ob4,
    ob4:"CE.1"::string as ce_1,
    ob4:"CE.2"::string as ce_2,
    ob4:"CE.3"::string as ce_3
 from oru_response_sgmt as b;


/*****************************************************************************************
-- 🐍 Using Python UDF to parse HL7 V2.x messages filtered for patient admit

TIP: Because the Python code is bound to a SQL Function, any user who knows SQL 
can use it even if they don't have strong python skills!

>> Python UDFs are in private preview, and do not yet support direct unstructured file 
>> access like java udfs enjoy today. This function reads the RAW_MSG column from the
>> RAW table produced by the Java UDTF earlier.
*****************************************************************************************/
select
    raw_msg,
    hl7pyparser(raw_msg) parsed
from raw
where message_type like 'ADT_A01'
limit 100;

/*****************************************************************************************
-- Snowflake enables you to store and query semi-structured data natively. 
-- Let's flatten out some patient admission records. With Snowflake, this is easy!
*****************************************************************************************/
with parsed_cte as (
select
    raw_msg,
    hl7pyparser(raw_msg) parsed
from raw
where message_type like 'ADT_A01')
select 
    parsed:evn:recorded_date_time:time_of_an_event:st::string as time_of_event,
    parsed:pv1:attending_doctor:id_number_st:st::string as op_id,
    parsed:pv1:attending_doctor:prefix_e_g_dr:st::string || ' ' ||
    parsed:pv1:attending_doctor:given_name:st::string || ' ' ||
    parsed:pv1:attending_doctor:family_name:st::string as attending_doctor_name,
    parsed:pid:patient_name:given_name:st::string as patient_given_name,
    parsed:pid:patient_name:family_name:st::string as patient_family_name,
    parsed:pid:sex:is:is::string as patient_sex,
    parsed:pv1:hospital_service:id:id::string as hospital_service,
    parsed:pv1:assigned_patient_location:bed:is::string as bed,
    parsed:pv1:assigned_patient_location:floor:st::string as floor_num,
    parsed:pv1:assigned_patient_location:point_of_care_id:id::string as point_of_care_id,
    raw_msg,
    parsed
from parsed_cte;



/*****************************************************************************************

While there are numerous messaging formats in HL7, the most common include: 
    ○ ACK (General Acknowledgment)
    ○ ADT: Admission, Discharge, and Transfer, which carry patient demographic information
    ○ ORM: Pharmacy/Treatment Order Message which carries information about an order. 
    ○ ORU: Observation message type transmits observations and results, such as clinical lab results and imaging reports, from the producing system. 
    ○ SIU: Schedule Information message type is used to create, modify, and delete patient appointments and has 14 different trigger events.

There are 51 types of ADT message, but a few common ADT messages include:
    ○ ADT-A01 – patient admit.
    ○ ADT-A02 – patient transfer.
    ○ ADT-A03 – patient discharge.
    ○ ADT-A04 – patient registration.
    ○ ADT-A05 – patient pre-admission.
    ○ ADT-A08 – patient information update.
    ○ ADT-A11 – cancel patient admit.
    ○ ADT-A12 – cancel patient transfer.
*****************************************************************************************/


-- More Examples
-- Using Java UDF to parse HL7 V2.x messages.
with base as (
    select
        raw_msg, -- column holding the 1 HL7v2.x raw message 
        hl7_hapi_udf_parser(raw_msg, false) as parsed
    from raw
)
select
    raw_msg,
    parse_json(parsed:"hl7_json") as hl7_json
from base;


-- queries allowing us to find specific HL7 Messages
select * from raw where message_sequence_num=1 and message_type='ORU_R01';
select * from raw where message_type='ORU_R01' and PARSED_STATUS='TRUE';
select * from raw where message_type like 'ADT_A01';


-- ⚠️ RESET ENVIROMENT ⚠️
drop database if exists hl7;
drop warehouse if exists hl7_wh;
