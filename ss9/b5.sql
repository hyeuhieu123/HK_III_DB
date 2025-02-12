-- 2
create index idx_creditLimit on customers(creditLimit);

-- 3
select c.customerNumber, c.customerName, c.city, c.creditLimit, c.country
from customers c
join offices o on c.postalCode = o.postalCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;

-- 4
explain analyze
select c.customerNumber, c.customerName, c.city, c.creditLimit, o.country
from customers c
join offices o on c.postalCode = o.postalCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;