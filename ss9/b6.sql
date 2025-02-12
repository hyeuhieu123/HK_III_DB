-- 2
create view view_orders_summary as
select c.customernumber, c.customername, count(o.ordernumber) as total_orders
from customers c
left join orders o on c.customernumber = o.customernumber
group by c.customernumber, c.customername;

-- 2
select customerNumber, customerName, total_orders
from view_orders_summary
where total_orders > 3;