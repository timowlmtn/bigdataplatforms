-- How to write a query to output the missing records for either of the two lists?
select c1.email
    , c2.email
from customer_1 c1
full outer join customer_2 c2 on c1.email = c2.email
where c1.email is null or c2.email is null