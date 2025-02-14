-- 3
CREATE VIEW view_film_category AS 
SELECT 
	film.film_id,
	film.title,
	category.name AS CategoryName
FROM film 
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id;

-- 4
CREATE VIEW view_high_value_customers AS
SELECT
	customer.customer_id,
	customer.first_name,
	customer.last_name,
	sum(payment.amount) AS total_payment
FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name
HAVING sum(payment.amount) > 100;

-- 5
CREATE INDEX idx_rental_rental_date ON rental(rental_date);
SELECT * FROM rental WHERE rental_date = '2005-06-14';
EXPLAIN SELECT * FROM rental WHERE rental_date = '2005-06-14';

-- 6
DELIMITER //
CREATE PROCEDURE CountCustomerRentals (IN customer_id INT, OUT rental_count INT)
BEGIN
	SELECT count(*) INTO rental_count
	FROM rental
	WHERE rental.customer_id = customer_id;
END;
// DELIMITER ;

-- 7
DELIMITER //
CREATE PROCEDURE GetCustomerEmail(IN customer_id INT, OUT email VARCHAR(50))
BEGIN
    SELECT email INTO email 
    FROM customer 
    WHERE customer_id = customer_id 
    LIMIT 1;
END;
// DELIMITER ;

-- 8
DROP INDEX idx_rental_rental_date ON rental;
DROP PROCEDURE CountCustomerRentals;
DROP PROCEDURE GetCustomerEmail;