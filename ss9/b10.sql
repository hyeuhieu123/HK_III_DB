-- 2

create index idx_productLine on products(productLine);


-- 3
create view view_total_sales as
select p.productLine,
       sum(od.quantityOrdered * od.priceEach) as total_sales,
       sum(od.quantityOrdered) as total_quantity
from orderdetails od
join products p on od.productCode = p.productCode
group by p.productLine;


-- 4
select * from view_total_sales;


-- 5
select 
    v.productLine,
    pl.textDescription,
    v.total_sales,
    v.total_quantity,
    case 
        when length(pl.textDescription) > 30 then concat(substring(pl.textDescription, 1, 30), '...')
        else pl.textDescription
    end as description_snippet,
    case
        when v.total_quantity > 1000 then (v.total_sales / v.total_quantity) * 1.1
        when v.total_quantity between 500 and 1000 then v.total_sales / v.total_quantity
        when v.total_quantity < 500 then (v.total_sales / v.total_quantity) * 0.9
    end as sales_per_product
from view_total_sales v
join productlines pl on v.productLine = pl.productLine
where v.total_sales > 2000000
order by v.total_sales desc;