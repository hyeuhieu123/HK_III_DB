use ss3;
create table student4(
	student_id int primary key auto_increment,
    student_name varchar(100) not null,
    email varchar(100) not null unique,
    date_of_birth date not null,
    gender enum('Male','Female','Other'),
    gpa decimal(3,2) check (gpa>=0 and gpa<=4)
);
INSERT INTO student4 (student_name, email, date_of_birth, gender, gpa)
VALUES
('Nguyen Van A', 'nguyenvana@example.com', '2000-05-15', 'Male', 3.50),
('Tran Thi B', 'tranthib@example.com', '1999-08-22', 'Female', 3.80),
('Le Van C', 'levanc@example.com', '2001-01-10', 'Male', 2.70),
('Pham Thi D', 'phamthid@example.com', '1998-12-05', 'Female', 3.00),
('Hoang Van E', 'hoangvane@example.com', '2000-03-18', 'Male', 3.60),
('Do Thi F', 'dothif@example.com', '2001-07-25', 'Female', 4.00),
('Vo Van G', 'vovang@example.com', '2000-11-30', 'Male', 3.20),
('Nguyen Thi H', 'nguyenthih@example.com', '1999-09-15', 'Female', 2.90),
('Bui Van I', 'buivani@example.com', '2002-02-28', 'Male', 3.40),
('Tran Thi J', 'tranthij@example.com', '2001-06-12', 'Female', 3.75);
select * from student4 where gpa > 3.0 and gender = 'Female';
select * from student4 where date_of_birth > '2000-01-01' order by gpa desc limit 1;
select * from student4 where date_of_birth = (select date_of_birth from student4 where student_id = 1);
update student4 set gpa = least(gpa + 0.5, 4.0) where gpa < 2.5 and student_id = student_id;
update student4 set gender = 'Other' where email like '%test%';
select student_name , floor(datediff(curdate(), date_of_birth) / 365) as age from student4;