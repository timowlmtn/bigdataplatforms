-- How to count the distinct number of missing records for the customer_2 table?
select count(distinct c1.email)
from customer_1 c1
full outer join customer_2 c2 on c1.email = c2.email
where c2.email is null;