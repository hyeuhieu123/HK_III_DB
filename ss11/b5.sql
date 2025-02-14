-- 3
CREATE VIEW View_Album_Artist AS
SELECT 
    Album.AlbumId AS AlbumId,
    Album.Title AS Album_Title,
    Artist.Name AS Artist_Name
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId;

SELECT * FROM View_Album_Artist;

-- 4
CREATE VIEW View_Customer_Spending AS
SELECT 
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    Customer.Email,
    COALESCE(SUM(Invoice.Total), 0) AS Total_Spending
FROM Customer
LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId;

SELECT * FROM View_Customer_Spending ORDER BY Total_Spending DESC;


-- 5
CREATE INDEX idx_Employee_LastName ON Employee(LastName);
SELECT * FROM Employee WHERE LastName = 'King';
EXPLAIN SELECT * FROM Employee WHERE LastName = 'King';

-- 6
DELIMITER //
CREATE PROCEDURE GetTracksByGenre(IN GenreId INT)
BEGIN
    SELECT 
        Track.TrackId AS TrackId,
        Track.Name AS Track_Name,
        Album.Title AS Album_Title,
        MediaType.Name AS Media_Type
    FROM Track
    LEFT JOIN Album ON Track.AlbumId = Album.AlbumId
    LEFT JOIN MediaType ON Track.MediaTypeId = MediaType.MediaTypeId
    WHERE Track.GenreId = GenreId;
END //
DELIMITER ;

CALL GetTracksByGenre(1);

-- 7
DELIMITER //
CREATE PROCEDURE GetTrackCountByAlbum(IN album_id INT)
BEGIN
    SELECT COUNT(*) AS Total_Tracks
    FROM Track
    WHERE AlbumId = album_id;
END;
// DELIMITER ;

-- 8
DROP VIEW View_Album_Artist;
DROP VIEW View_Customer_Spending;
DROP PROCEDURE IF EXISTS GetTracksByGenre;
DROP PROCEDURE IF EXISTS GetTrackCountByAlbum;
DROP INDEX idx_Employee_LastName ON Employee;