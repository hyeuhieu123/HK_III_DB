USE world;

-- 2
DELIMITER //
CREATE PROCEDURE Language(IN c_language VARCHAR(255))
BEGIN
	SELECT  CountryCode, Language, Percentage
    FROM countrylanguage
    WHERE Language = c_language AND Percentage > 50;
END;
// DELIMITER ;

-- 3
CALL Language('Spain');

-- 4
DROP PROCEDURE IF EXISTS Language; 
