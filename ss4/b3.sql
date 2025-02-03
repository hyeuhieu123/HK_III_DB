create database ss3;
use ss3;

create table customer (
    customer_id int auto_increment primary key,
    customer_name varchar(50) not null,
    birthday date not null,
    sex bit not null,
    job varchar(50),
    phone_number char(11) not null unique,
    email varchar(100) not null unique,
    address varchar(255) not null
);

insert into customer (customer_name, birthday, sex, job, phone_number, email, address)
values
('tran duc minh', '1999-04-20', 1, 'developer', '09012345678', 'minh.tran@example.com', 'ha noi'),
('le thu huong', '2001-06-15', 0, 'designer', '09123456780', 'huong.le@example.com', 'ho chi minh'),
('pham van trung', '1997-09-10', 1, 'teacher', '09234567890', 'trung.pham@example.com', 'da nang'),
('nguyen thi lan', '2003-12-05', 0, 'student', '09345678901', 'lan.nguyen@example.com', 'hai phong'),
('vo van tung', '2000-11-25', 1, null, '09456789012', 'tung.vo@example.com', 'can tho'),
('do thi phuong', '2002-08-30', 0, 'nurse', '09567890123', 'phuong.do@example.com', 'hue'),
('ngo van quang', '1998-07-22', 1, null, '09678901234', 'quang.ngo@example.com', 'nha trang'),
('tran thi mai', '2004-03-18', 0, 'accountant', '09789012345', 'mai.tran@example.com', 'ha long'),
('le van binh', '2005-05-12', 1, 'engineer', '09890123456', 'binh.le@example.com', 'quang ninh'),
('pham thi chi', '2006-01-08', 0, 'researcher', '09901234567', 'chi.pham@example.com', 'vung tau');

update customer
set customer_name = 'pham duc hoang', birthday = '2003-02-10'
where customer_id = 1;

delete from customer
where month(birthday) = 9;

select 
    customer_id,
    customer_name,
    birthday,
    case when sex = 1 then 'nam' else 'nữ' end as gender,
    phone_number
from customer
where birthday > '2000-01-01';

select * from customer
where job is null;
