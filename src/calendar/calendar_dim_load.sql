insert into WAREHOUSE.DIM_CALENDAR(DATE,
                                   YEAR,
                                   MONTH,
                                   MONTH_NAME,
                                   DAY_OF_MON,
                                   DAY_OF_WEEK,
                                   WEEK_OF_YEAR,
                                   DAY_OF_YEAR,
                                   WEEKDAY,
                                   DAYNAME)
select *
from (with years as (select dateadd(day, seq4(), '2010-01-01')::date date
                     from table (generator(rowcount => (14 * 365 + 3))))
      select date
           , date_part(year, date)       year
           , date_part(month, date)      month
           , monthname(date)             month_name
           , date_part(dayofmonth, date) day_of_mon
           , date_part(dayofweek, date)  day_of_week
           , date_part(weekofyear, date) week_of_year
           , date_part(dayofyear, date)  day_of_year
           , date_part(weekday, date)    weekday

           , dayname(date)               dayname
      from years);


select min(date), max(date)
from WAREHOUSE.DIM_CALENDAR;