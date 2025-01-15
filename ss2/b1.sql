/*

	INT: Dữ liệu số nguyên.

	•	VARCHAR: Dữ liệu chuỗi văn bản có độ dài thay đổi.

	•	CHAR: Dữ liệu chuỗi văn bản có độ dài cố định.

	•	DATE: Dữ liệu ngày tháng.

	•	DECIMAL: Dữ liệu số thập phân.

	•	BOOLEAN: Dữ liệu giá trị đúng/sai.


*/
create table student(
	student_id int,
	student_name varchar(10),
    student_birthdate date,
    average_number float(2, 2)
)