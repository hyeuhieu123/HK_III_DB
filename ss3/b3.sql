use ss3;
create table student2 (
    student_id int primary key auto_increment,
    student_name varchar(100) not null,
    email varchar(100) not null unique,
    age int check (age >= 0)
);
INSERT INTO student2 (student_name, email, age) 
VALUES ('Nguyen Van A', 'nguyenvana@example.com', 22),
('Le Thi B', 'lethib@example.com', 20), 
('Tran Van C', 'tranvanc@example.com', 23), 
('Pham Thi D', 'phamthid@example.com', 21);
delete from student2 where student_id = 2;