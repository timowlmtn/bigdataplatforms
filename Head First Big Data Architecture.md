# Head First Big Data Architecture

by Tim Burns

## Chapter 1 - Patterns in Big Data Processing

* Discuss common design patterns in Big Data
* The Normal Forms
* Domain Modelling
* The Star Schema
* Learn to recognize the benefits and drawbacks of each

### Data Refinement Tiers

* The Landing Zone and the Data Lake
* The Processing Layer - Transformations
* The Data Warehousing Layer - 3rd Normal Form and Star Schemas

## Chapter 2 - The Landing Zone and the Data Lake

* Expected Consistency in the Landing Zone
* Evolving the Landing Zone Schema through Time
* Handling Timezones with Disparate Data Sources

## Chapter 3 - The Processing Layer

* Merging like data from multiple sources
* Pivoting Data
* Using Window Functions on Data

## Chapter 4 - The Star Schema and Third Normal Form

* The Difference between the Operational and Analytical Use Cases
* Window Functions and Slowly Changing Dimensions
* Managing Exceptions

## Chapter 5 - Validating Data for Consistency

* Waterfall Reporting
* Raising Exceptions while processing Data
* Remediating Data Problems

## Chapter 6 - Big Data in Practice - The Radio Playlist Data Warehouse

* Apache Spark, Snowflake, and Databricks
* Simple patterns to pull API data using Python
* Securing your Data Lake
* Loading Data from the Landing Zone
* Processing the Data into a Normal Form
* Creating a Star Schema from the Data
* Using analytics tools to answer business questions

## Chapter 7 - Big Data in Practice - Consumer Product Data

### Consumer data sources
* Melissa
* Acxiom
* Salesforce

### Common Star Schemas in CPG
* Retailer
* Product
* Inventory

### Common Analytics in CPG
* The Pareto Principle (80-20 Rule)
* Seasonality and Year over Year Reporting
* Fiscal Calendars

## Chapter 8 - Big Data in Practice - Healthcare Data

### Clinical and Claims Data
* HIPAA Public Data Sources of Test Data

### Healthcare Interchange Formats

* HL7
* FIHR

### Healthcare Analytics
* Common Star Schemas in Healthcare
* Common Analytics in Healthcare