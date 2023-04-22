We’ve been building data lakes for a few years, and I’ve recently been in several debates on platform cost. 
Is Snowflake cheaper? What about Redshift and Big Query? Should I go back to Apache Spark on a local cluster?

I don’t think this is the best question to ask.  Instead, I think Eric Ries’ book, “The Lean Startup,” offers a 
better model for determining the cost-effectiveness of our data platforms.

The better question is, “Who is the customer of my data, what do they want, and what is the cheapest and fastest 
way to deliver that value?”  

How does that question compare to the traditional method of building a data warehouse?  It’s a classic waterfall 
build model:  We gather the data, we normalize it, create a star schema, maybe create a data mart or an OLAP 
database, and then we give customers access to that data.  We load all the data we can because the customer 
can independently slice, dice, and answer their use case question.

What’s happened to me in the past is that we’ve loaded tons of data and processed it only to discover the data 
the customer needs is not present. Therefore, the data we loaded is not required, and the cost - our billed compute 
cost from the provider - is the measure of the cost of the system.  Furthermore, because we are reluctant to exclude 
data, the cost of processing data the customer doesn’t need can become a fixed overhead.

What can we do to focus on building data products that the customer can validate in as little time as possible?  
First, we start from the BI Analytics position with specific questions we answer.  We build the data to provide 
the answer the customer seeks, and then we add more data to answer the following question.  We don’t make the 
OLAP cube that allows the customer to slice and dice for some unknown answer.  How will we know they won’t waste 
their time slicing and dicing when the data they need isn’t there?  I’m not saying we shouldn’t provide arbitrary 
query ability.  We should provide that as part of a follow on of the proof of base use cases.

The importance of simplicity comes in when the data produced doesn’t meet the customers’ needs.  Quality open-source 
tools like “dbt” or airflow simplify our development pipeline and make it easy to pivot.  Modifying configurations 
is simpler than modifying or writing new code.  If we focus on simplicity, we can reduce the cost of improving the 
data product given customer feedback, which we want to reduce.

So, when we measure cost, the ultimate measure is in our ability to take a customer's question and realize it, 
and the relative cost of running on a platform is optional.

