USE world;

-- 2
DELIMITER //
CREATE PROCEDURE GetEnglishSpeakingCountriesWithCities(IN language VARCHAR(255))
BEGIN
	SELECT
		ct.Name as CountryName,
		SUM(c.Population) as TotalPopulation
    FROM country ct
    JOIN countrylanguage cl ON ct.Code = cl.CountryCode
    JOIN city c ON ct.Code = c.CountryCode
    WHERE cl.Language = language AND cl.IsOfficial = 'T'
    GROUP BY ct.Name
    HAVING TotalPopulation > 5000000
    ORDER BY TotalPopulation DESC
    LIMIT 10;
END //
// DELIMITER ;

-- 3
CALL GetEnglishSpeakingCountriesWithCities('English');

-- 4
DROP PROCEDURE IF EXISTS GetEnglishSpeakingCountriesWithCities;