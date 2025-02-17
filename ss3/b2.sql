use ss3;
create table student1 (
    student_id int primary key auto_increment,
    student_name varchar(100) not null,
    email varchar(100) not null unique,
    age int check (age >= 0)
);
INSERT INTO student1 (student_name, email, age) 
VALUES ('Nguyen Van A', 'nguyenvana@example.com', 22),
('Le Thi B', 'lethib@example.com', 20), 
('Tran Van C', 'tranvanc@example.com', 23), 
('Pham Thi D', 'phamthid@example.com', 21);
update student1 set email='newemail@example.com' where student_id=3;