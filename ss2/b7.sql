use b5;
create table chitiethoadon(
MaHD int not null,
MaSP int not null,
SoLuong int not null,
primary key(MaHD,MaSP),
foreign key(MaHD) references hoadon(MaHD),
foreign key(MaSP) references sanpham(MaSP)
)