USE world;

-- 2
DELIMITER //
CREATE PROCEDURE GetCountriesByCityNames()
BEGIN
	SELECT
		ct.Name AS CountryName,
        cl.Language AS OfficialLanguage,
        SUM(c.Population) AS TotalPopulation
	FROM country ct
    JOIN city c ON c.CountryCode = ct.Code
    JOIN countrylanguage cl ON cl.CountryCode = ct.Code
    WHERE c.Name LIKE 'A%' AND cl.IsOfficial = 'T'
    GROUP BY ct.Name, cl.Language
    HAVING TotalPopulation > 2000000
    ORDER BY CountryName ASC;
END //
// DELIMITER ;

-- 3
CALL GetCountriesByCityNames();

-- 4
DROP PROCEDURE IF EXISTS GetCountriesByCityNames;