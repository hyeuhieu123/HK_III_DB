USE world;

-- 2
DELIMITER //
CREATE PROCEDURE GetCountriesWithLargeCities()
BEGIN
	SELECT
		ct.Name as CountryName,
        SUM(c.Population) as TotalPopulation
	FROM country ct
    JOIN city c on c.CountryCode = ct.Code
    WHERE ct.Continent = 'Asia'
    GROUP BY ct.Name
    HAVING TotalPopulation > 10000000
    ORDER BY TotalPopulation DESC;
END //
// DELIMITER ;

-- 3
CALL GetCountriesWithLargeCities();

-- 4
DROP PROCEDURE IF EXISTS GetCountriesWithLargeCities;