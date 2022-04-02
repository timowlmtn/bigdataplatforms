-- How could I get a distinct list of all the customers in CUSTOMER_1 and CUSTOMER_2?
with all_emails as (
    select distinct coalesce(c1.email, c2.email) as email
    from customer_1 c1
    full outer join customer_2 c2 on c1.email = c2.email
)
select * from all_emails;