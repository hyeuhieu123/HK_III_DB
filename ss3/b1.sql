create database ss3;
use ss3;
create table student (
    student_id int primary key not null,
    student_name varchar(100) not null,
    age int check (age >= 18),
    gender varchar(10) check (gender in ('male', 'female', 'other')) not null,
    registration_date datetime default current_timestamp not null
);
insert into student (student_id, student_name, age, gender, registration_date)
values 
    (1, 'a', 20, 'male', default),
    (2, 'b', 18, 'female', default), 
    (3, 'c', 18, 'other', default); 