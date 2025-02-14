-- 2
CREATE VIEW view_track_details AS
SELECT 
    track.trackid, 
    track.name AS track_name,  
    album.title AS album_title, 
    artist.name AS artist_name,  
    track.unitprice
FROM track
JOIN album ON track.albumid = album.albumid
JOIN artist ON album.artistid = artist.artistid
WHERE track.unitprice > 0.99;

SELECT * FROM view_track_details;

-- 3
CREATE VIEW View_Customer_Invoice AS
SELECT 
    Customer.CustomerId, 
    concat(Customer.LastName, ' ', Customer.FirstName) AS FullName, 
    Customer.Email, 
    sum(Invoice.Total) AS Total_Spending, 
    Employee.LastName
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY Customer.CustomerId, Customer.LastName, Customer.FirstName, Customer.Email, Employee.LastName
HAVING Total_Spending > 50;

SELECT * FROM View_Customer_Invoice;

-- 4
CREATE VIEW view_top_selling_tracks AS
SELECT 
    track.trackid, 
    track.name AS track_name,  
    genre.name AS genre_name,  
    sum(invoiceline.quantity) AS total_sales
FROM track
JOIN invoiceline ON track.trackid = invoiceline.trackid
JOIN genre ON track.genreid = genre.genreid
GROUP BY track.trackid, track.name, genre.name
HAVING total_sales > 10;

SELECT * FROM view_top_selling_tracks;

-- 5
CREATE INDEX idx_Track_Name ON Track(Name);
SELECT * FROM Track WHERE Name LIKE '%Love%';
EXPLAIN SELECT * FROM Track WHERE Name LIKE '%Love%';

-- 6
CREATE INDEX idx_Invoice_Total ON Invoice(Total);
SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;
EXPLAIN SELECT * FROM Invoice WHERE Total BETWEEN 20 AND 100;

-- 7
DELIMITER //
CREATE PROCEDURE GetCustomerSpending(IN customer_id INT, OUT total_spent DECIMAL(10,2))
BEGIN
    SELECT sum(total_spending) INTO total_spent
    FROM view_customer_invoice
    WHERE customerid = customer_id;
END;
// DELIMITER ;

DROP PROCEDURE GetCustomerSpending;
CALL GetCustomerSpending(1, @total_spent);
SELECT @total_spent;

-- 8
DELIMITER //
CREATE PROCEDURE SearchTrackByKeyword(IN p_keyword VARCHAR(255))
BEGIN
    SELECT * 
    FROM track
    WHERE name LIKE concat('%', p_keyword, '%');
END;
// DELIMITER ;

CALL SearchTrackByKeyword('lo');

-- 9
DELIMITER //
CREATE PROCEDURE GetTopSellingTracks(IN p_min_sales INT, IN p_max_sales INT)
BEGIN
    SELECT * 
    FROM view_top_selling_tracks
    WHERE total_sales BETWEEN p_min_sales AND p_max_sales;
END;
// DELIMITER ;

CALL GetTopSellingTracks(10, 50);

-- 9
DROP VIEW view_track_details;
DROP VIEW view_customer_invoice;
DROP VIEW view_top_selling_tracks;
DROP INDEX idx_track_name ON track;
DROP INDEX idx_invoice_total ON invoice;
DROP PROCEDURE GetCustomerSpending;
DROP PROCEDURE SearchTrackByKeyword;
DROP PROCEDURE GetTopSellingTracks;