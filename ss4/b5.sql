use ss4;
create table employee3(
employee_id char(4) not null,
employee_name varchar(50) not null,
date_of_birth date ,
sex bit not null check (sex in (1,0)),
base_salary  int not null check(base_salary>0),
phone_number char(11) not null unique
);
INSERT INTO employee3 (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number)VALUES
('E001', 'Nguyen Van A', '2004-12-11', 1, 4000000, '0987836473'),
('E002', 'Tran Thi B', '2004-01-12', 1, 3500000, '0982378673'),
('E003', 'Tran Thi c', '2004-02-03', 1, 3500000, '0976734562'),
('E004', 'Tran Thi d', '2004-10-04', 0, 5000000, '0987352772'),
('E005', 'Tran Thi e', '2003-03-12', 1, 4000000, '0987236568'),

select employee_id,employee_name,date_of_birth,phone_number from employee3;
update employee3 set base_salary = base_salary * 1.1 where sex = 0;
delete from employee3 where year(date_of_birth) = 2003;