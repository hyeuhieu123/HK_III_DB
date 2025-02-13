USE world;

-- 2
DELIMITER //
CREATE PROCEDURE GetLargeCitiesByCountry(IN country_code VARCHAR(10))
BEGIN
    SELECT 
        c.ID AS CityID,
        c.Name AS CityName,
        c.Population
    FROM city c
    WHERE c.CountryCode = country_code
        AND c.Population > 1000000
    ORDER BY c.Population DESC;
END //
// DELIMITER ;

-- 3
CALL GetLargeCitiesByCountry('USA');

-- 4
DROP PROCEDURE IF EXISTS GetLargeCitiesByCountry;