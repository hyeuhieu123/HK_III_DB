-- 2
select orderNumber, orderDate, status
from orders
where orderDate between '2003-01-01' and '2003-12-31'
  and status = 'Shipped';

explain analyze
select orderNumber, orderDate, status
from orders
where orderDate between '2003-01-01' and '2003-12-31'
  and status = 'Shipped';


create index idx_orderDate_status on orders(orderDate, status);

explain analyze
select orderNumber, orderDate, status
from orders
where orderDate between '2003-01-01' and '2003-12-31'
  and status = 'Shipped';

-- 3
select customerNumber, customerName, phone
from customers
where phone = '2035552570';

create unique index idx_customerNumber on customers(customerNumber);

explain analyze
select customerNumber, customerName, phone
from customers
where phone = '2035552570';


-- 4
drop index idx_orderDate_status on orders;
drop index idx_customerNumber on customers;
drop index idx_phone on customers;