USE ss13_4;

-- 2
CREATE TABLE enrollments_history(
	history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    action VARCHAR(50) NOT NULL,
    timestamp DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 3
DELIMITER //
CREATE PROCEDURE register_course(
    IN p_student_name VARCHAR(50), 
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_available_seats INT;
    DECLARE v_enrollment_count INT;
    DECLARE v_action VARCHAR(50);

    START TRANSACTION;

    SELECT student_id INTO v_student_id 
    FROM students 
    WHERE student_name = p_student_name;

    SELECT course_id, available_seats INTO v_course_id, v_available_seats
    FROM courses 
    WHERE course_name = p_course_name;

    SELECT COUNT(*) INTO v_enrollment_count
    FROM enrollments 
    WHERE student_id = v_student_id AND course_id = v_course_id;
    
    IF v_enrollment_count > 0 THEN
        SET v_action = 'FAILLED';
        INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
        VALUES (v_student_id, v_course_id, v_action, NOW());
        ROLLBACK;
    ELSE
        IF v_available_seats > 0 THEN
            INSERT INTO enrollments (student_id, course_id) 
            VALUES (v_student_id, v_course_id);
            
            UPDATE courses
            SET available_seats = available_seats - 1
            WHERE course_id = v_course_id;

            SET v_action = 'REGISTERED';
            INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
            VALUES (v_student_id, v_course_id, v_action, NOW());

            COMMIT;
        ELSE
            SET v_action = 'FAILLED';
            INSERT INTO enrollments_history (student_id, course_id, action, timestamp)
            VALUES (v_student_id, v_course_id, v_action, NOW());
            ROLLBACK;
        END IF;
    END IF;
END;
// DELIMITER ;

-- 4
CALL register_course('Nguyễn Văn An', 'Lập trình C');

-- 5
SELECT * FROM enrollments;
SELECT * FROM courses;
SELECT * FROM enrollments_history;