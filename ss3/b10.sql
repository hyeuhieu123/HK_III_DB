use k23;
create table students (
    student_id int primary key auto_increment,
    student_name varchar(100) not null,
    email varchar(100) not null unique,
    date_of_birth date not null
);
create table enrollments (
    enrollment_id int primary key auto_increment,
    student_id int,
    course_name varchar(255) not null,
    enrollment_date date not null,
    foreign key (student_id) references students(student_id)
);
INSERT INTO students (student_name, email, date_of_birth)
VALUES
('Nguyen Van A', 'nguyenvana@example.com', '2000-05-15'),
('Tran Thi B', 'tranthib@example.com', '1999-08-22'),
('Le Van C', 'levanc@example.com', '2001-01-10'),
('Pham Thi D', 'phamthid@example.com', '1998-12-05'),
('Hoang Van E', 'hoangvane@example.com', '2002-03-18');
INSERT INTO enrollments (student_id, course_name, enrollment_date)
VALUES
(1, 'Math 101', '2025-01-10'),
(1, 'Physics 101', '2025-01-15'),
(2, 'Chemistry 101', '2025-01-12'),
(2, 'Biology 101', '2025-01-20'),
(3, 'History 101', '2025-02-01'),
(3, 'Geography 101', '2025-02-05'),
(4, 'Computer Science 101', '2025-03-01'),
(4, 'Programming Basics', '2025-03-10'),
(5, 'English Literature', '2025-04-01'),
(5, 'Creative Writing', '2025-04-05');
select * from students where student_name like '%Nguyen%' and date_of_birth >= '2000-01-01';
update students set email = 'updated_email@example.com' where student_name = 'Nguyen Van A';
select * from enrollments where course_name like '%101%';
delete from  enrollments where enrollment_date < '2025-02-01';