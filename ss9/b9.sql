-- 2
create index idx_customerNumber on payments(customerNumber);

-- 3
create view view_customer_payments 
as select customerNumber, sum(amount) as total_payments, count(customerNumber) as payment_count
from payments
group by customerNumber;


-- 4
select * from view_customer_payments;

-- 5
select c.customerName, c.country, v.total_payments, v.payment_count,(v.total_payments / v.payment_count) as average_payment, c.creditLimit
from view_customer_payments v
join customers c on v.customerNumber = c.customerNumber
where v.total_payments > 150000 and v.payment_count > 3
order by v.total_payments desc
limit 5;