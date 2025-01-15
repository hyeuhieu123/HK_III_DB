use b5;
create table KHACHHANG(
MaKH int primary key,
TenKH varchar(255),
SoDienThoai varchar(255) not null
);
create table HOADON(
MaHD int primary key,
NgayLap date,
MaKH int,
foreign key (MaKH) references KHACHHANG(MaKH)
);