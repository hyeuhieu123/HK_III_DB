USE world;

-- 2
CREATE VIEW OfficialLanguageView AS
SELECT 
    ct.Code AS CountryCode,
    ct.Name AS CountryName,
    cl.Language AS Language
FROM country ct
JOIN countrylanguage cl ON ct.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T';

-- 3
SELECT * FROM OfficialLanguageView;

-- 4
CREATE INDEX idx_city_name ON city(Name);

-- 5
DELIMITER //
CREATE PROCEDURE GetSpecialCountriesAndCities(IN language_name VARCHAR(50))
BEGIN
	SELECT
		ct.Name AS CountryName, 
        c.Name AS CityName, 
        c.Population AS CityPopulation,
        country_total.Population AS TotalPopulation
	FROM city c
    JOIN country ct ON c.CountryCode = ct.Code
    JOIN countrylanguage cl ON ct.Code = cl.CountryCode
    JOIN (
        SELECT CountryCode, SUM(Population) AS Population 
        FROM city
        GROUP BY CountryCode
        HAVING Population > 5000000
    ) AS country_total ON ct.Code = country_total.CountryCode
    WHERE cl.Language = language_name 
      AND cl.IsOfficial = 'T'
      AND c.Name LIKE 'New%'
    ORDER BY country_total.Population DESC
    LIMIT 10;
END //
// DELIMITER ;

-- 6
CALL GetSpecialCountriesAndCities('English');

DROP PROCEDURE IF EXISTS GetSpecialCountriesAndCities;