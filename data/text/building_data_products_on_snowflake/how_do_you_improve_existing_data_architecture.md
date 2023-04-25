# How would I improve an existing Data Architecture?

## First Step - Interview and Discover

1. Interview stakeholders
2. Identify problems using the data
3. Propose a solution

## How would I improve an existing Data Architecture

### Users don't trust the data

1. Implement data quality checks
2. Do we have deduplication built into the pipeline?
3. Is the data good to be begin with?
4. What kinds of QA are we doing on the data?

### Data is not meeting SLA

1. Are we using a modern stack (Snowpipe, Kafka, airflow, dbt, incremental processing)
2. Review counts on the SQL for large temporary queries
3. Review partitioning on the data to see we focus our data write operations
4. Look for parallelism in the process

### New data is taking the team too long to add?

1. Check the data model to see that it is extensible
2. Use normalization steps in data acquisition
3. If Snowflake, consider using Variants or PRIMARY_COL, SECONDARY_COL, ... to address relational gaps

### Data is not realizing business value

1. Build a business dashboard that answers real questions
2. Use a visualization tool that analysts know

## How do you choose a Data Lake or Data Warehouse

### I would choose a data lake for these issues

1. If I have many data sources in varied format to synthesize
2. If I have a high-end data science team that will want data both raw and refined
3. If I have a very large amount of data to process
4. If I have complex AI needs on data
5. If I have a lot of semi-structured or unstructured data

#### I would choose a data Warehouse

1. If I have a clear and fixed set of use cases
2. If Data Governance is crucial
3. If my primary customer is a business analyst using a BI tool
4. When the data is largely structured

## Explain Different Types of Data Stores used in Organizations

### Normalized Data Store, Dimensional Data Store, Data Mart

1. A Data Warehouse can combine any of these
2. A Data Warehouse must store history
3. 
### OLAP and Cubes

1. OLAP stores are generally output for slicing and dicing

### OLTP and Operational Data Stores

Those are the outputs from the operational databases

## How to choose a relational or non-relational Database for your solution?

### Choose Relational Database

1. Structured Data
2. Data Integrity is most important
3. Predictable usage and data

### Choose Non-relational Database

1. Semi-structured or unstructured data
2. When you need to scale to sizes out of the range of relational databases
3. When you need flexibility in data modelling to support many customer types

## How to choose batch vs real-time processing for your solution

1. Choose Batch for processing large volumes on set times
2. Choose Real-time for event driven use cases
3. When the data is needed ASAP

## Where would you use an index?

1. Use an index in a relational database for frequently used queries
2. Consider querying vs system performance

3. Indexing fails if there are too many indexes
4. If data updates are killing the indexes

## Improving Database's Performance

1. CPU, Memory, Disk Space.
2. Tuning and Optimizing Queries
3. Review Indexes


