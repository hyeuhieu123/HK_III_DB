USE world;

-- 2
CREATE VIEW CountryLanguageView AS
SELECT 
    ct.Code AS CountryCode,
    ct.Name AS CountryName,
    cl.Language,
    cl.IsOfficial
FROM country ct
JOIN countrylanguage cl ON ct.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T';

-- 3
SELECT * FROM CountryLanguageView;

-- 4
DELIMITER //
CREATE PROCEDURE GetLargeCitiesWithEnglish()
BEGIN
	SELECT
		c.Name as CityName,
        ct.Name as CountryName,
        c.Population
	FROM city c
    JOIN country ct ON c.CountryCode = ct.Code
    JOIN countrylanguage cl ON ct.Code = cl.CountryCode
    WHERE cl.Language = 'English' AND cl.IsOfficial = 'T' AND c.Population > 1000000
    ORDER BY c.Population DESC
    LIMIT 20;
END //
// DELIMITER ;

-- 5
CALL GetLargeCitiesWithEnglish();

-- 6
DROP PROCEDURE IF EXISTS GetLargeCitiesWithEnglish;