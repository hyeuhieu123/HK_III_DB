-- 2
create view view_customer_status as
select customerNumber, customerName, creditLimit,
       case
           when creditLimit > 100000 then 'High'
           when creditLimit between 50000 and 100000 then 'Medium'
           else 'Low'
       end as status
from customers;

-- 3
select * from view_customer_status;

-- 4
select status, count(customerNumber) as customer_count
from view_customer_status
group by status
order by customer_count desc;