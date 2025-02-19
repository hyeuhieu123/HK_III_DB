CREATE DATABASE ss13_8;

USE ss13_8;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE enrollments_history(
	history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    action VARCHAR(50) NOT NULL,
    timestamp DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);

-- 2
CREATE TABLE student_status (
    student_id INT PRIMARY KEY,
    status ENUM('ACTIVE', 'GRADUATED', 'SUSPENDED') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 3
INSERT INTO student_status (student_id, status) VALUES
(1, 'ACTIVE'),    -- Nguyễn Văn An có thể đăng ký
(2, 'GRADUATED'); -- Trần Thị Ba đã tốt nghiệp, không thể đăng ký

-- 4
DELIMITER //

CREATE PROCEDURE register_student_course(
    IN p_student_name VARCHAR(50),
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE student_id INT;
    DECLARE course_id INT;
    DECLARE available_seats INT;
    DECLARE student_status ENUM('ACTIVE', 'GRADUATED', 'SUSPENDED');
    DECLARE enrollment_exists INT;

    START TRANSACTION;

    -- Kiểm tra sinh viên tồn tại
    SELECT student_id INTO student_id
    FROM students
    WHERE student_name = p_student_name;

    IF student_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    -- Kiểm tra khóa học tồn tại
    SELECT course_id, available_seats INTO course_id, available_seats
    FROM courses
    WHERE course_name = p_course_name;

    IF course_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course does not exist';
    END IF;

    -- Kiểm tra sinh viên đã đăng ký khóa học chưa
    SELECT COUNT(*) INTO enrollment_exists
    FROM enrollments
    WHERE student_id = student_id AND course_id = course_id;

    IF enrollment_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Already enrolled';
    END IF;

    -- Kiểm tra trạng thái sinh viên
    SELECT status INTO student_status
    FROM student_status
    WHERE student_id = student_id;

    IF student_status IN ('GRADUATED', 'SUSPENDED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student not eligible';
    END IF;

    -- Kiểm tra số ghế trống trong khóa học
    IF available_seats <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available seats';
    END IF;

    -- Đăng ký sinh viên vào khóa học
    INSERT INTO enrollments (student_id, course_id)
    VALUES (student_id, course_id);

    -- Cập nhật số ghế trống trong khóa học
    UPDATE courses
    SET available_seats = available_seats - 1
    WHERE course_id = course_id;

    -- Ghi lại lịch sử đăng ký vào bảng enrollments_history
    INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
    VALUES (student_id, course_id, 'REGISTERED', NOW());

    COMMIT;
END;
// DELIMITER ;


-- 5
CALL register_student_course('Nguyễn Văn A', 'Lập trình C');

SELECT * FROM enrollments;
SELECT * FROM courses;
SELECT * FROM enrollment_history;

SHOW PROCEDURE STATUS WHERE Db = 'ss13_8';
DROP PROCEDURE IF EXISTS register_student_course;