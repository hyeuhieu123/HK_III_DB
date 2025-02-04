/* Câu 1 */
SELECT MaSV, HoSV, TenSV, HocBong
FROM DMSV
ORDER BY MaSV ASC;

/* Câu 2 */
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh
FROM DMSV
ORDER BY CASE
             WHEN Phai = 'Nam' THEN 1
             WHEN Phai = 'Nữ' THEN 2
          END;

/* Câu 3 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, HocBong
FROM DMSV
ORDER BY NgaySinh ASC, HocBong DESC;

/* Câu 4 */
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE TenMH LIKE 'T%'
ORDER BY TenMH;

/* Câu 5 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, Phai
FROM DMSV
WHERE RIGHT(TenSV, 1) = 'I';

/* Câu 6 */
SELECT MaKhoa, TenKhoa
FROM DMKhoa
WHERE SUBSTRING(TenKhoa, 2, 1) = 'N';

/* Câu 7 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen
FROM DMSV
WHERE HoSV LIKE '%Thị%';

/* Câu 8 */
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, HocBong
FROM DMSV
WHERE HocBong > 100000
ORDER BY MaKhoa DESC;

/* Câu 9 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, NoiSinh, HocBong
FROM DMSV
WHERE HocBong >= 150000 AND NoiSinh = 'Hà Nội';

/* Câu 10 */
SELECT MaSV, MaKhoa, Phai
FROM DMSV
WHERE MaKhoa IN ('AV', 'VL');

/* Câu 11 */
SELECT MaSV, NgaySinh, NoiSinh, HocBong
FROM DMSV
WHERE NgaySinh BETWEEN '1991-01-01' AND '1992-06-05';

/* 12 */
SELECT MaSV, NgaySinh, Phai, MaKhoa
FROM DMSV
WHERE HocBong BETWEEN 80000 AND 150000;

/* 13 */
SELECT MaMH, TenMH, SoTiet
FROM DMMH
WHERE SoTiet > 30 AND SoTiet < 45;

/* 14 */
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, TenKhoa, Phai
FROM DMSV
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
WHERE Phai = 'Nam' AND (DMKhoa.MaKhoa = 'AV' OR DMKhoa.MaKhoa = 'TH');

/* 15 */
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen
FROM DMSV
WHERE Phai = 'Nữ' AND TenSV LIKE '%N%';

/* 16 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NoiSinh, NgaySinh
FROM DMSV
WHERE NoiSinh = 'Hà Nội' AND MONTH(NgaySinh) = 2;

/* 17 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, HocBong
FROM DMSV
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) > 20;

/* 18 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, TenKhoa
FROM DMSV
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) BETWEEN 20 AND 25;

/* 19 */
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh
FROM DMSV
WHERE YEAR(NgaySinh) = 1990 AND MONTH(NgaySinh) BETWEEN 3 AND 5;

/* 20 */
SELECT MaSV, Phai, MaKhoa, 
       CASE 
           WHEN HocBong > 500000 THEN 'Học bổng cao'
           ELSE 'Mức trung bình'
       END AS MucHocBong
FROM DMSV;

/* 21 */
SELECT COUNT(*) AS TongSoSinhVien
FROM DMSV;

/* 22 */
SELECT COUNT(*) AS TongSinhVien, 
       SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS TongSinhVienNu
FROM DMSV;

/* 23 */
SELECT MaKhoa, COUNT(*) AS TongSinhVien
FROM DMSV
GROUP BY MaKhoa;

/* 24 */
SELECT MaMH, COUNT(DISTINCT MaSV) AS SoLuongSinhVien
FROM KetQua
GROUP BY MaMH;

/* 25 */
SELECT MaSV, COUNT(DISTINCT MaMH) AS SoMonHocDaHoc
FROM KetQua
GROUP BY MaSV;

/* 26 */
SELECT DMKhoa.MaKhoa, SUM(DMSV.HocBong) AS TongHocBong
FROM DMSV
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
GROUP BY DMKhoa.MaKhoa;

/* 27 */
SELECT DMKhoa.MaKhoa, MAX(DMSV.HocBong) AS HocBongCaoNhat
FROM DMSV
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
GROUP BY DMKhoa.MaKhoa;

/* 28 */
SELECT DMKhoa.MaKhoa, 
       SUM(CASE WHEN Phai = 'Nam' THEN 1 ELSE 0 END) AS TongNam,
       SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS TongNu
FROM DMSV
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa
GROUP BY DMKhoa.MaKhoa;

/* 29 */
SELECT TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, COUNT(*) AS SoLuongSinhVien
FROM DMSV
GROUP BY Tuoi;

/* 30 */
SELECT YEAR(NgaySinh) AS NamSinh, COUNT(*) AS SoSinhVien
FROM DMSV
GROUP BY YEAR(NgaySinh)
HAVING COUNT(*) = 2;

/* 31 */
SELECT NoiSinh, COUNT(*) AS SoLuongSinhVien
FROM DMSV
GROUP BY NoiSinh
HAVING COUNT(*) > 2;
