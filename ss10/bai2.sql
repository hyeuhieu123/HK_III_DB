USE world;

-- 2
DELIMITER //
CREATE PROCEDURE CalculatePopulation(IN p_countryCode VARCHAR(10), OUT total_population INT)
BEGIN
	SELECT SUM(Population)
    FROM country
    WHERE Code = p_countryCode;
   
END;
// DELIMITER ;

-- 3
SET @total_population = 0;
CALL CalculatePopulation('VN', @total_population);

-- 4
DROP PROCEDURE IF EXISTS CalculatePopulation; 
