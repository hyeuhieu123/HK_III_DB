CREATE DATABASE TicketFilm;
USE TicketFilm;
create table tbl_phim (
    phim_id int primary key auto_increment,
    ten_phim nvarchar(30),
    loai_phim nvarchar(25),
    thoi_gian int
);

create table tbl_phong (
    phong_id int primary key auto_increment,
    ten_phong nvarchar(20),
    trang_thai tinyint
);

create table tbl_ghe (
    ghe_id int primary key auto_increment,
    phong_id int,
    so_ghe varchar(10),
    foreign key (phong_id) references tbl_phong(phong_id) on delete cascade
);

create table tbl_ve (
    phim_id int,
    ghe_id int,
    ngay_chieu datetime,
    trang_thai nvarchar(20),
    foreign key (phim_id) references tbl_phim(phim_id) on delete cascade,
    foreign key (ghe_id) references tbl_ghe(ghe_id) on delete cascade
);

insert into tbl_phim (ten_phim, loai_phim, thoi_gian) values
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);

insert into tbl_phong (ten_phong, trang_thai) values
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);

insert into tbl_ghe (phong_id, so_ghe) values
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

insert into tbl_ve (phim_id, ghe_id, ngay_chieu, trang_thai) values
(1, 1, '2008-10-20', 'Đã bán'),
(1, 3, '2008-11-20', 'Đã bán'),
(1, 4, '2008-12-23', 'Đã bán'),
(2, 1, '2009-02-14', 'Đã bán'),
(3, 1, '2009-02-14', 'Đã bán'),
(2, 5, '2009-03-08', 'Chưa bán'),
(2, 3, '2009-03-08', 'Chưa bán');

-- 1
select * 
from tbl_phim 
order by thoi_gian;

-- 2
select ten_phim 
from tbl_phim 
order by thoi_gian 
desc limit 1;

-- 3
select ten_phim 
from tbl_phim 
order by thoi_gian 
asc limit 1;

-- 4
select so_ghe 
from tbl_ghe 
where so_ghe like 'A%';

-- 5
alter table tbl_phong 
modify column trang_thai varchar(25);

-- 6
delimiter //
create procedure update_and_show_phong()
begin
    update tbl_phong 
    set trang_thai = case 
        when trang_thai = '0' then 'Đang sửa'
        when trang_thai = '1' then 'Đang sử dụng'
        else 'Unknown'
    end;
    
    select * from tbl_phong;
end //
delimiter ;

call update_and_show_phong();

-- 7
select ten_phim 
from tbl_phim 
where length(ten_phim) > 15 and length(ten_phim) < 25;

-- 8
select concat(ten_phong, ' - ', trang_thai) as 'Trạng thái phòng chiếu' 
from tbl_phong;

-- 9
create view tbl_rank as
select row_number() over (order by ten_phim) 
as stt, ten_phim, thoi_gian from tbl_phim;

-- 10
alter table tbl_phim 
add column mo_ta nvarchar(255);
update tbl_phim set mo_ta = concat('Đây là bộ phim thể loại ', loai_phim);
select * 
from tbl_phim;
update tbl_phim set mo_ta = replace(mo_ta, 'bộ phim', 'film');
select * 
from tbl_phim;

-- 11
alter table tbl_ghe 
drop foreign key tbl_ghe_ibfk_1;
alter table tbl_ve 
drop foreign key tbl_ve_ibfk_1;
alter table tbl_ve 
drop foreign key tbl_ve_ibfk_2;

-- 12
delete from tbl_ghe;

-- 13
select ngay_chieu, date_add(ngay_chieu, interval 5000 minute) 
as 'Ngày chiếu +5000 phút' from tbl_ve;