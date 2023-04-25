# Data Mesh
## Why we need a new approach to managing data

### Oreilly
- Data Architecture - The Hard Parts
- Data Mesh

# Introduction

- Digital Transformations
  - Microservices and Containerization
  - Smaller systems that do one thing well
  - Distributed architecture where components focus on one business domain

## Organizational Shifts

- Avoid functional division
  - Group people around a particular goal

- Relationship with data
  - We start with the data and
  - We use questions to investigate the data
    - Machine Learning
    - Traditional analytics
  
### Data Pipeline


(           governance                                  )
Operational Data Plane --> ETL --> Analytical Data Plane

# Data Warehouse
1. Extract
2. Transform
   1. Load DW 
   2. Start Schema
3. Reports

## Lake Architecture

Modelling can lose signal in the data (remove the star schema)

Use semi-structured format to get the data to analytics sooner

### Centralized Architecture

- There is no normalization of the data


# Data Mesh

A decentralized approach to manage analytical data at scale in order to address data given
organizational complexity.

- Uses both archtectural design
- Uses communication structure of the organizatoin
- Decentralized

## Objectives

- Align business, technical and data domains
- Close gap between operational and analytical data
- Remove pipeline and localize code and data into one unit with a clear contract
- Clear ownership of domain data products
- Allow generalized ot use data
- Embed governance into each data product

## Principles

- Domain Ownership
  - Domains are accountable for their own data
- Data as a product
  - Data is a product we can share or sell
- Self-serve data infrastructure
  - Different domain owners need autonomy 
  - Avoid bottlenecks
- Federated governance
  - Provide governance around multiple domains

## Important Questions

1. How does the Data Platform fit into the bigger picture at the enterprise?

   1. Longitudinal Health Record
   2. Break data into domains and deliver
      1. Avoid specific questions
      
2. Enabling analysts and data scientists
   1. Traditional method - assign data engineering team to the work
   2. New method - build a team around a domain and have them build it
      1. Common technology can provide governance (Repeatability)
      2. Team has the business questions to answer
      3. Team is cross-functional

## Domain-Driven Design

Tackling Complexity - Eric Evans

1. Bounded Context
   1. Create a language for a particular bounded context
   2. Create a mapping between contexts
2. Product thinking
   1. Keeps different silos speaking the same language
   2. Usable, Valuable, Feasible

## Baseline Data Usability

1. Discoverable
   1. Can access in their mode of access
2. Trustworthy
   1. SLA

## Logical Architecture

1. Data inputs
2. Data Transform Code
3. Data outputs

## Data Mesh Platform Objectives

1. Platform Plane


## Governance
1. Data to the right people at the right time with integrity
2. Need to balance autonomous domains with central control
3. Automation

Thinking in Systems - Donella Meadows

## Operational Model

- Computational policies embedded in the mesh
- Ensure there is an agent that can measure quality metrics
  - Data quality is discoverable just as any other product

## Zero Trust Architecture

- We have every component have 0 trust of any other components
- There is not black and white - in or out of the system
  - Even if you are in the system, you still have 0 trust
  - Trust is managed by explicit roles and policies