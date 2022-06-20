select * from information_schema.packages where language = 'python';

select current_role();

insert into stage.STOCKS_TABLE(symbol, QUANTITY, PRICE)
values ('MultiPlan', 1, 5.43);

insert into stage.STOCKS_TABLE(symbol, QUANTITY, PRICE)
values ('MultiPlan', 2, 5.00);

insert into stage.STOCKS_TABLE(symbol, QUANTITY, PRICE)
values ('MultiPlan', 3, 4.20);


select *
    from stage.STOCKS_TABLE;

use schema stage;

select hl7_handler.symbol, total
  from stocks_table, table(hl7_handler(symbol,  price, QUANTITY) over (partition by symbol));

