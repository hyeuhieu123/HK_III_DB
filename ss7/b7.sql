create database StudentTest;
use StudentTest;

-- Tạo bảng Student (Sinh viên)
create table Student (
    RN int auto_increment primary key,
    Name varchar(20) not null unique,
    Age tinyint not null
);

-- Tạo bảng Test (Bài kiểm tra)
create table Test (
    TestID int auto_increment primary key,
    Name varchar(20) not null unique
);

-- Tạo bảng StudentTest (Bảng điểm sinh viên)
create table StudentTest (
    RN int not null,
    TestID int not null,
    Date date,
    Mark float,
    primary key(RN, TestID),
    foreign key(RN) references Student(RN),
    foreign key(TestID) references Test(TestID)
);

-- Thêm ràng buộc UNIQUE vào bảng Student và Test
alter table Student add constraint UniqueNames unique (Name);
alter table Test add constraint UniqueTestNames unique (Name);

-- Thêm ràng buộc UNIQUE cho cặp (RN, TestID) trong bảng StudentTest
alter table StudentTest add constraint RNTestIDUnique unique key (RN, TestID);

-- Thêm cột Status vào bảng Student
alter table Student add column Status varchar(10); 

-- Thêm ràng buộc xóa dữ liệu liên quan khi sinh viên hoặc bài kiểm tra bị xóa
alter table StudentTest drop foreign key StudentTest_ibfk_1;
alter table StudentTest add constraint StudentTest_ibfk_1 foreign key (RN) references Student(RN) on delete cascade;
alter table StudentTest drop foreign key StudentTest_ibfk_2;
alter table StudentTest add constraint StudentTest_ibfk_2 foreign key (TestID) references Test(TestID) on delete cascade;

-- Chèn dữ liệu vào bảng Student
insert into Student (RN, Name, Age) values 
(1, 'Nguyen Hong Ha', 20),
(2, 'Trung Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

-- Chèn dữ liệu vào bảng Test
insert into Test (TestID, Name) values 
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

-- Chèn dữ liệu vào bảng StudentTest
insert into StudentTest (RN, TestID, Date, Mark) 
values 
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 2, '2006-07-18', 1);

-- 1
select 
    s.Name as StudentName, 
    t.Name as TestName, 
    st.Mark as Mark, 
    st.Date as TestDate 
from 
    Student s
join 
    StudentTest st on s.RN = st.RN
join 
    Test t on st.TestID = t.TestID;

-- 2 
select s.RN, s.Name, s.Age 
from Student s 
where not exists (
    select 1 from StudentTest st where st.RN = s.RN
);

-- 3 
select 
    s.Name as StudentName, 
    t.Name as TestName, 
    st.Mark as  Mark, 
    st.Date as TestDate 
from 
    Student s
join 
    StudentTest st on s.RN = st.RN
join 
    Test t on st.TestID = t.TestID
where 
    st.Mark < 5
order by 
    s.Name, t.Name;


-- 4 
select s.Name as StudentName, round(avg(st.Mark), 2) as AverageMark
from Student s 
join StudentTest st on s.RN = st.RN 
group by s.Name
order by AverageMark desc;

-- 5 
select s.Name as StudentName, round(avg(st.Mark), 2) as AverageMark
from Student s 
join StudentTest st on s.RN = st.RN 
group by s.Name 
order by AverageMark desc 
limit 1;

-- 6
select 
    s.Name as StudentName, 
    t.Name as TestName
from 
    Student s
left join 
    StudentTest st on s.RN = st.RN
left join 
    Test t on st.TestID = t.TestID
order by 
    s.Name, t.Name;

-- 7
select 
    s.Name as StudentName, 
    t.Name as TestName
from 
    Student s
left join 
    StudentTest st on s.RN = st.RN
left join 
    Test t on st.TestID = t.TestID
order by 
    s.Name, t.Name;

-- 8 
update Student 
set Age = Age + 1;

-- 9
update Student 
set Status = case 
    when Age < 30 then 'Young' 
    else 'Old' 
end;

-- 10
select   
	s.Name as StudentName, 
    t.Name as TestName, 
    st.Mark as Score, 
    st.Date as TestDate from StudentTest order by Date asc;

-- 11
select s.Name as StudentName, s.RN, s.Age, st.Mark as AverageMark
from Student s 
join StudentTest st on s.RN = st.RN 
where s.Name like 'T%' and st.Mark > 4.5;

-- 12
select 
    s.RN as StudentID,
    s.Name as StudentName,
    s.Age,
    round(avg(st.Mark), 2) as AverageMark,
    rank() over (order by avg(st.Mark) desc) as Rank
from Student s
join StudentTest st on s.RN = st.RN
group by s.RN
order by Rank;

-- 13
alter table Student 
modify column Name nvarchar(max);

-- 14
update Student
set Name = case 
    when Age > 20 then concat('Old ', Name)
    else concat('Young ', Name)
end;

-- 15
update Student
set Name = concat('Young ', Name)
where Age <= 20;

-- 16
delete from Test 
where TestID not in (select distinct TestID from StudentTest);

-- 17
delete from StudentTest where Mark < 5;