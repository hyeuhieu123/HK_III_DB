-- 2
create index idx_productLine on products(productLine);

-- 3
create view view_highest_priced_products as
select p.productLine, p.productName, p.MSRP
from products p
where p.MSRP = (
    select max(MSRP)
    from products
    where productLine = p.productLine
);

-- 4
select * from view_highest_priced_products;

-- 5
select v.productLine, v.productName, v.MSRP, pl.textDescription
from view_highest_priced_products v
join productlines pl on v.productLine = pl.productLine
order by v.MSRP desc
limit 10;
 