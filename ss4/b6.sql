use ss4;
create table department2(
    department_id int primary key auto_increment,
    department_name varchar(50) not null unique,
    address varchar(50) not null
);
create table employee1(
    employee_id char(10) primary key,
    employee_name varchar(50) not null,
    date_of_birth date,
    sex bit not null,
    base_salary int not null check(base_salary>0),
    phone_number char(11) not null unique,
    department_id int not null,
    constraint fk_employee_department foreign key(department_id) references department2(department_id)
);
INSERT INTO department2 (department_name, address) VALUES
('Sales', '123 Main St'),
('Marketing', '456 Elm St'),
('Human Resources', '789 Oak St'),
('Finance', '101 Pine St'),
('IT', '202 Maple St');
INSERT INTO employee1 (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number, department_id) VALUES
('E0001', 'Nguyen A', '1990-01-15', 1, 5000, '01234567890', 1),
('E0002', 'Tran B', '1985-05-20', 0, 6000, '01234567891', 2),
('E0003', 'Le C', '1992-03-25', 1, 5500, '01234567892', 3),
('E0004', 'Pham D', '1988-07-10', 0, 7000, '01234567893', 4),
('E0005', 'Hoang E', '1987-09-18', 1, 6500, '01234567894', 5),
('E0006', 'Nguyen F', '1993-11-30', 0, 4900, '01234567895', 1),
('E0007', 'Tran G', '1989-02-12', 1, 5200, '01234567896', 2),
('E0008', 'Le H', '1995-06-22', 0, 4800, '01234567897', 3),
('E0009', 'Pham I', '1991-10-04', 1, 7000, '01234567898', 4),
('E0010', 'Hoang J', '1986-12-16', 0, 7200, '01234567899', 5);
alter table employee1 drop foreign key fk_employee_department;
DELETE FROM department2  WHERE department_id =1;
DELETE FROM employee1 WHERE department_id = 1;
ALTER TABLE employee1 ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES department2(department_id);
update deparment2 set department_name ='sale deparment' where department_id = 1;
select department_id,department_name,address from deparmtent2;
select e.employee_id, e.employee_name, e.date_of_birth, e.sex, e.base_salary, e.phone_number, d.department_name
from employee1 e
join department2 d on e.department_id = d.department_id;