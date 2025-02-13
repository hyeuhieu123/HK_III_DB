USE world;

-- 2
DELIMITER //
CREATE PROCEDURE getAllCountry_code(IN code VARCHAR(10))
BEGIN
	SELECT  ID, Name, Population
    FROM city
    WHERE CountryCode = code;
END;
// DELIMITER ;

-- 3
CALL getAllCountry_code('QAT');

-- 4
DROP PROCEDURE IF EXISTS getAllCountry_code; 
