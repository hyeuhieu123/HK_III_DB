use b4;
insert into nhanvien(MaNV,HoTen,NgayVaoLam,SoLuong)
values (1, 'Nguyen Van A', '2025-01-10', 5000);
insert into nhanvien(MaNV,HoTen,NgayVaoLam,SoLuong)
VALUES (2, 'Tran Thi B', '2024-12-05', 5500);
insert into nhanvien(MaNV,HoTen,NgayVaoLam,SoLuong)
VALUES (3, 'Le Minh C', '2023-08-15', 6000);

update nhanvien 
set SoLuong=7000
where MaNV=1;

delete from nhanvien where MaNV=3;