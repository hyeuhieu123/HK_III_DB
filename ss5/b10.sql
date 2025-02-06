
DELETE a 
FROM appointments a
JOIN doctors d ON a.DoctorID = d.DoctorID
WHERE d.FullName = 'Phan Huong' 
AND a.AppointmentDate < NOW();

SELECT 
    a.AppointmentID, 
    p.FullName AS PatientName, 
    d.FullName AS DoctorName, 
    a.AppointmentDate, 
    a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate ASC;

UPDATE appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
SET a.Status = 'Dang chờ'
WHERE p.FullName = 'Nguyen Van An' 
AND d.FullName = 'Phan Huong' 
AND a.AppointmentDate >= NOW();

SELECT 
    a.AppointmentID, 
    p.FullName AS PatientName, 
    d.FullName AS DoctorName, 
    a.AppointmentDate, 
    a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate ASC;


SELECT 
    p.FullName AS PatientName, 
    d.FullName AS DoctorName, 
    a.AppointmentDate, 
    m.Diagnosis
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
JOIN medicalrecords m ON a.PatientID = m.PatientID AND a.DoctorID = m.DoctorID
WHERE (a.PatientID, a.DoctorID) IN (
    SELECT PatientID, DoctorID
    FROM appointments
    GROUP BY PatientID, DoctorID
    HAVING COUNT(AppointmentID) >= 2
)
ORDER BY p.FullName, d.FullName, a.AppointmentDate;



SELECT 
    UPPER(CONCAT('BỆNH NHÂN: ', p.FullName, ' - BÁC SĨ: ', d.FullName)) AS Info,
    a.AppointmentDate, 
    m.Diagnosis, 
    a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
LEFT JOIN medicalrecords m ON a.PatientID = m.PatientID AND a.DoctorID = m.DoctorID
ORDER BY a.AppointmentDate ASC;

SELECT 
    UPPER(CONCAT('BỆNH NHÂN: ', p.FullName, ' - BÁC SĨ: ', d.FullName)) AS Info,
    a.AppointmentDate, 
    COALESCE(m.Diagnosis, 'Không có chẩn đoán') AS Diagnosis, 
    a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
LEFT JOIN medicalrecords m ON a.PatientID = m.PatientID AND a.DoctorID = m.DoctorID
ORDER BY a.AppointmentDate ASC;