use ss3;
create table Books(
	book_id int primary key auto_increment,
    title varchar(100) not null,
    price decimal(10,2) not null,
    stock int not null
);
INSERT INTO Books (title, price, stock)
VALUES
('how to think like', 120.00, 10),
('automatic habit', 90.00, 3),
('harry porter', 150.00, 20),

select *from Books where price > 100;
delete from Books where title like '%Pride%';