/*
-- primary key là một ràng buộc được sử dụng để xác định duy nhất mỗi bản ghi trong bảng. Một bảng chỉ có thể có một khóa chính và giá trị trong cột được đặt làm khóa chính phải là duy nhất và không được null
-- Ràng buộc NOT NULL đảm bảo rằng cột đó không thể chứa giá trị rỗng (null).
-- foreign key là ràng buộc dùng để thiết lập mối quan hệ giữa hai bảng. Giá trị trong cột khóa ngoại phải trùng khớp với giá trị trong cột khóa chính của bảng tham chiếu.
*/

create table staff (
staff_id int primary key,
staff_name varchar(50),
birthdate date
);
create table customer(
cus_id int primary key,
cus_name varchar(20) not null,
email varchar(20) not null
);
create table orders(
order_id int primary key,
order_date date,
cus_id int,
foreign key (cus_id) references customer(cus_id)
);
