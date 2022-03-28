insert into purchases(email, amount, purchase_date)
select 'calvin@comics.com', 1.00, '2022-03-27 16:54:42.189000000 -07:00'
union
select 'calvin@comics.com', 1.00, '2022-02-27 16:54:42.189000000 -07:00'
union select 'calvin@comics.com', 1.00, '2022-01-27 16:54:42.189000000 -07:00'
union select 'calvin@comics.com', 1.00, '2021-12-27 16:54:42.189000000 -07:00'
union select 'calvin@comics.com', 1.00, '2021-12-27 16:54:42.189000000 -07:00'
union  select 'calvin@comics.com', 1.00, '2021-11-27 16:54:42.189000000 -07:00';


insert into purchases(email, amount, purchase_date)
select 'hobbes@comics.com', 1.00, '2021-03-27 16:54:42.189000000 -07:00'
union
select 'hobbes@comics.com', 1.00, '2021-02-27 16:54:42.189000000 -07:00'
union select 'hobbes@comics.com', 1.00, '2021-01-27 16:54:42.189000000 -07:00'
union select 'hobbes@comics.com', 1.00, '2021-12-27 16:54:42.189000000 -07:00';

insert into purchases(email, amount, purchase_date)
select 'hobbes@history.com', 1.00, '2021-03-27 16:54:42.189000000 -07:00'
union
select 'hobbes@history.com', 1.00, '2021-02-27 16:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-01-27 16:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-02-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-03-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-04-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-05-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-06-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.00, '2021-07-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.20, '2021-08-27 14:54:42.189000000 -07:00'
union select 'hobbes@history.com', 1.50, '2021-12-27 16:54:42.189000000 -07:00';

insert into purchases(email, amount, purchase_date)
select 'suzy@comics.com', 1.00, '2021-03-27 18:54:42.189000000 -07:00'
union
select 'suzy@comics.com', 1.00, '2021-02-27 16:54:42.189000000 -07:00';

insert into purchases(email, amount, purchase_date)
select 'calvin@history.com', 1000.00, '1540-03-27 18:54:42.189000000 -07:00';