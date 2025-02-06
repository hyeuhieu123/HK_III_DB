USE ss5;
create table  patients (
    PatientID int primary key auto_increment,
    FullName varchar(100) not null,
    DateOfBirth date,
    Gender varchar(10),
    PhoneNumber varchar(15)
);
create table doctors (
    DoctorID int primary key auto_increment,
    FullName varchar(100) not null,
    Specialization varchar(50),
    PhoneNumber varchar(15),
    Email varchar(100) unique
);
create table appointments (
    AppointmentID int primary key auto_increment,
    PatientID int,
    DoctorID int,
    AppointmentDate datetime,
    Status varchar(20),
    foreign key (PatientID) references patients(PatientID) on delete cascade,
    foreign key (DoctorID) references doctors(DoctorID) on delete cascade
);
create table medicalrecords (
    RecordID int primary key auto_increment,
    PatientID int,
    DoctorID int,
    Diagnosis text,
    TreatmentPlan text,
    foreign key (PatientID) references patients(PatientID) on delete cascade,
    foreign key (DoctorID) references doctors(DoctorID) on delete cascade
);


INSERT INTO Patients (FullName, DateOfBirth, Gender, PhoneNumber)
VALUES
    ('Nguyen Van An', '1985-05-15', 'Nam', '0901234567'),
    ('Tran Thi Binh', '1990-09-12', 'Nu', '0912345678'),
    ('Pham Van Cuong', '1978-03-20', 'Nam', '0923456789'),
    ('Le Thi Dung', '2000-11-25', 'Nu', '0934567890'),
    ('Vo Van Em', '1982-07-08', 'Nam', '0945678901'),
    ('Hoang Thi Phuong', '1995-01-18', 'Nu', '0956789012'),
    ('Ngo Van Giang', '1988-12-30', 'Nam', '0967890123'),
    ('Dang Thi Hanh', '1992-06-10', 'Nu', '0978901234'),
    ('Bui Van Hoa', '1975-10-22', 'Nam', '0989012345');


INSERT INTO Doctors (FullName, Specialization, PhoneNumber, Email)
VALUES
    ('Le Minh', 'Noi Tong Quat', '0908765432', 'leminh@hospital.vn'),
    ('Phan Huong', 'Nhi Khoa', '0918765432', 'phanhuong@hospital.vn'),
    ('Nguyen Tuan', 'Tim Mach', '0928765432', 'nguyentuan@hospital.vn'),
    ('Dang Quang', 'Than Kinh', '0938765432', 'dangquang@hospital.vn'),
    ('Hoang Dung', 'Da Lieu', '0948765432', 'hoangdung@hospital.vn'),
    ('Vu Hanh', 'Phu San', '0958765432', 'vuhanh@hospital.vn'),
    ('Tran An', 'Noi Tiet', '0968765432', 'tranan@hospital.vn'),
    ('Lam Phong', 'Ho Hap', '0978765432', 'lamphong@hospital.vn'),
    ('Pham Ha', 'Chan Thuong Chinh Hinh', '0988765432', 'phamha@hospital.vn');


INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
VALUES
    (1, 2, '2025-01-20 09:00:00', 'Da Dat'),
    (3, 1, '2025-01-21 10:30:00', 'Da Dat'),
    (5, 3, '2025-01-22 08:00:00', 'Da Dat'),
    (2, 4, '2025-01-23 14:00:00', 'Da Dat'),
    (4, 5, '2025-01-24 11:00:00', 'Da Dat'),
    (6, 6, '2025-01-25 15:00:00', 'Da Dat'),
    (7, 7, '2025-01-26 16:30:00', 'Da Dat'),
    (8, 8, '2025-01-27 09:00:00', 'Da Dat'),
    (9, 9, '2025-01-28 10:00:00', 'Da Dat');


INSERT INTO MedicalRecords (PatientID, DoctorID, Diagnosis, TreatmentPlan)
VALUES
    (1, 2, 'Cam Cum', 'Nghi ngoi, uong nhieu nuoc, su dung paracetamol 500mg khi sot.'),
    (3, 1, 'Dau Dau Man Tinh', 'Kiem tra huyet ap dinh ky, giam cang thang, su dung thuoc giam dau khi can.'),
    (5, 3, 'Roi Loan Nhip Tim', 'Theo doi tim mach 1 tuan/lan, dung thuoc dieu hoa nhip tim.'),
    (2, 4, 'Dau Cot Song', 'Vat ly tri lieu, giam van dong manh.'),
    (4, 5, 'Viêm Da Tiep Xuc', 'Su dung kem boi da, tranh tiep xuc voi chat gay di ung.'),
    (6, 6, 'Thieu Mau', 'Tang cuong thuc pham giau sat, bo sung vitamin.'),
    (7, 7, 'Tieu Duong Type 2', 'Duy tri che do an lanh manh, kiem tra duong huyet thuong xuyen.'),
    (8, 8, 'Hen Suyen', 'Su dung thuoc xit hen hang ngay, tranh tiep xuc bui ban.'),
    (9, 9, 'Gay Xuong', 'Bo bot, kiem tra xuong dinh ky, vat ly tri lieu sau khi thao bot.');
select p.FullName AS PatientName,d.FullName AS DoctorName,a.AppointmentDate,d.Specialization,a.Status from appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
where a.AppointmentDate between '2025-01-20' and '2025-01-25'
order by a.AppointmentDate asc
limit 3;

select p.FullName as PatientName,p.DateOfBirth,d.FullName as DoctorName,d.Specialization,m.Diagnosis from appointments a
join patients p on a.PatientID = p.PatientID
join doctors d on a.DoctorID = d.DoctorID
join medicalrecords m on a.PatientID = m.PatientID and a.DoctorID = m.DoctorID
where a.AppointmentDate between '2025-01-20' and '2025-01-25'
order by a.AppointmentDate asc
limit 5;

select 
    p.fullname as patient_name, 
    p.dateofbirth, 
    timestampdiff(year, p.dateofbirth, a.appointmentdate) as age_at_appointment, 
    a.appointmentdate, 
    m.diagnosis, 
    m.treatmentplan
from appointments a
join patients p on a.patientid = p.patientid
join medicalrecords m on a.patientid = m.patientid
where a.appointmentdate = (
    select min(a2.appointmentdate) 
    from appointments a2 
    where a2.patientid = a.patientid
)
order by a.appointmentdate asc;