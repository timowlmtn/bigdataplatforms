/*
 Suppose a mailer was only sent out to all the customers in the customer_1 list, but not the customer 2 list.
 I record every email sent in an email_sent table by email.  How would I use a CTE to query the email_sent
 table for the customers in the customer_2 list that were not sent the email?
 */
with unsent_customer_2 as (
  select distinct c2.email
  from customer_1 c1
  full outer join customer_2 c2 on c1.email = c2.email
  where c1.email is null
)
select us2.email
from unsent_customer_2 us2
left outer join unsent_customer_2 es on us2.email = es.email;