CREATE DATABASE QuanLySinhVien;
USE QuanLySinhVien;

create table students (
    student_id int primary key,
    student_name varchar(50),
    age int,
    email varchar(100)
);

create table subjects (
    subject_id int primary key,
    subject_name varchar(50)
);

create table classes (
    class_id int primary key,
    class_name varchar(50)
);

create table marks (
    subject_id int,
    student_id int,
    mark int,
    primary key (subject_id, student_id),
    foreign key (subject_id) references subjects(subject_id),
    foreign key (student_id) references students(student_id)
);

create table class_students (
    student_id int,
    class_id int,
    primary key (student_id, class_id),
    foreign key (student_id) references students(student_id),
    foreign key (class_id) references classes(class_id)
);

insert into subjects (subject_id, subject_name) values
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');

insert into marks (mark, subject_id, student_id) values
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

insert into students (student_id, student_name, age, email) values
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taien@sport.vn');

insert into classes (class_id, class_name) values
(1, 'C0706L'),
(2, 'C0708G');

insert into class_students (student_id, class_id) values
(1, 1),
(2, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 1);

-- hiển thị danh sách tất cả các học viên
select * 
from students;

-- hiển thị danh sách tất cả các môn học
select * 
from subjects;

-- tính điểm trung bình của từng học sinh
select student_id, 
avg(mark) as avg_mark
from marks
group by student_id;

-- hiển thị môn học có học sinh thi được trên 9 điểm
select m.student_id, s.subject_name, m.mark
from marks m
join subjects s on m.subject_id = s.subject_id
where m.mark > 9;

-- hiển thị điểm trung bình của từng học sinh theo chiều giảm dần
select student_id, 
avg(mark) as avg_mark
from marks
group by student_id
order by avg_mark desc;

-- cập nhật thêm dòng chữ "Day la mon hoc" vào trước các bản ghi trên cột subject_name
update subjects
set subject_name = concat('Day la mon hoc ', subject_name);

-- viết trigger để kiểm tra độ tuổi nhập vào trong bảng students yêu cầu age >15 và age < 50
delimiter //
create trigger check_student_age
before insert on students
for each row
begin
    if new.age <= 15 or new.age >= 50 then
        signal sqlstate '45000'
        set message_text = 'Tuoi cua hoc vien phai lon hon 15 va nho hon 50!';
    end if;
end;
//
delimiter ;

-- loại bỏ quan hệ giữa tất cả các bảng (xóa ràng buộc khóa ngoại)
show create table marks;
alter table marks 
drop foreign key marks_ibfk_1;
alter table marks 
drop foreign key marks_ibfk_2;
alter table class_students 
drop foreign key class_students_ibfk_1;
alter table class_students 
drop foreign key class_students_ibfk_2;

-- xóa học viên có student_id = 1
delete 
from students 
where student_id = 1;

-- thêm cột status vào bảng students (kiểu dữ liệu bit, mặc định là 1)
alter table students 
add column status bit default 1;

-- cập nhật giá trị status trong bảng students thành 0
update students 
set status = 0;