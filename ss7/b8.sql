create database quan_ly_ban_hang;
use quan_ly_ban_hang;

create table customer (
    cId int primary key,
    Name varchar(25) not null,
    cAge int not null
);

create table products (
    pID int primary key,
    pName varchar(25) not null,
    pPrice int not null
);

create table orders (
    oID int primary key,
    cID int not null,
    oDate datetime not null,
    oTotalPrice int,
    foreign key (cID) references customer(cID)
);

create table order_detail (
    oID int,
    pID int,
    odQTY int,
    primary key (oID, pID),
    foreign key (oID) references orders(oID),
    foreign key (pID) references products(pID)
);

insert into customer (cID, Name, cAge) values
(1, 'Minh Quan', 10), 
(2, 'Ngoc Oanh', 20), 
(3, 'Hong Ha', 50);

insert into orders (oID, cID, oDate, oTotalPrice) values
(1, 1, '2006-03-21', null),
(2, 2, '2006-03-23', null),
(3, 1, '2006-03-16', null);

insert into products(pID, pName, pPrice) values
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

insert into order_detail (oID, pID, odQTY) values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 2 
select oID, cID, oDate, oTotalPrice 
from Orders
order by oDate DESC;


-- 3
select pName, pPrice 
from Products 
where pPrice = (select max(pPrice) from Products);

-- 4
select c.name as CustomerName, p.pName as ProductName
from Customer c
join Orders o on c.cID = o.cID
join Order_Detail od on o.oID = od.oID
join Products p on od.pID = p.pID
order by c.cID, p.pName;
 
-- 5
select c.name as CustomerName
from Customer c
left join Orders o on c.cID = o.cID
where o.oID is null; 

-- 6
select o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
from Orders o
join Order_Detail od on o.oID = od.oID
join Products p on od.pID = p.pID
order by o.oID, o.oDate;
 
-- 7
select o.oID, o.oDate, sum(od.odQTY * p.pPrice) as Total
from Orders o
join Order_Detail od on o.oID = od.oID
join Products p on od.pID = p.pID
group by o.oID, o.oDate
order by Total desc;

-- 8
-- Xóa Khóa ngoại
alter table orders drop foreign key orders_ibfk_1;
alter table order_detail drop foreign key order_detail_ibfk_1;
alter table order_detail drop foreign key order_detail_ibfk_2;

-- Xóa khóa chính
alter table customer drop primary key;
alter table products drop primary key;
alter table orders drop primary key;
alter table order_detail drop primary key;