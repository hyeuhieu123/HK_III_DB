-- 2
explain analyze
select * from customers
where country = 'Germany';

-- 3
create index idx_country on customers(country);


-- 4
explain analyze
select * from customers
where country = 'Germany';

-- Trước khi tạo chỉ mục, MySQL phải thực hiện quét toàn bộ bảng, dẫn đến hiệu suất kém khi bảng có nhiều dữ liệu.
-- Sau khi tạo chỉ mục, MySQL có thể tìm kiếm nhanh chóng và chỉ phải kiểm tra ít bản ghi hơn, giúp cải thiện tốc độ truy vấn.

-- 5
drop index idx_country on customers;