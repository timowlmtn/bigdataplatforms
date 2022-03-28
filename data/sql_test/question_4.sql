with all_emails as (
    select distinct coalesce(c1.email, c2.email) as email
    from customer_1 c1
    full outer join customer_2 c2 on c1.email = c2.email
)
select rank() over (order by sum(coalesce(
    case when PURCHASE_DATE > dateadd(year, -1, current_timestamp) then amount
        else null end, 0)) desc) top_purchaser
     , sum(case when PURCHASE_DATE > dateadd(year, -1, current_timestamp) then amount else 0 end) yearly_amount
    , ae.email
from all_emails ae
 left outer join purchases p on p.email = ae.email
group by ae.email
qualify top_purchaser = 1 or yearly_amount = 0;