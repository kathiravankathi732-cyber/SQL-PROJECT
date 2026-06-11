use project;
SELECT *FROM Rides
WHERE fare > 200;
SELECT *FROM Users
WHERE signup_date > '2023-01-01';
SELECT *FROM Drivers
WHERE rating > 4.5;
SELECT *FROM Rides
WHERE distance_km BETWEEN 5 AND 15;
SELECT *FROM Rides
WHERE status = 'completed'
AND fare > 100;
SELECT *FROM Users
WHERE city IN ('Chennai', 'Bangalore');
SELECT *FROM Drivers
WHERE driver_name LIKE 'A%';
SELECT r.*FROM Rides r
JOIN Payments p
ON r.ride_id = p.ride_id
WHERE p.payment_method = 'UPI';
SELECT *FROM Rides
WHERE fare <> 0;
SELECT *
FROM Users
WHERE MONTH(signup_date) = 1;

## SELECT + WHERE + JOINS ##

SELECT u.user_name, r.fare
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
WHERE r.fare > 200;

SELECT d.driver_name, r.distance_km
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
WHERE r.distance_km > 10;

SELECT u.user_name, r.ride_id, p.payment_status
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
JOIN Payments p ON r.ride_id = p.ride_id
WHERE p.payment_status = 'failed';

SELECT u.user_name, u.city AS user_city,
       d.city AS driver_city
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
JOIN Drivers d ON r.driver_id = d.driver_id
WHERE u.city <> d.city;

SELECT r.ride_id,
       u.user_name,
       d.driver_name,
       r.fare,
       r.status
FROM Rides r
JOIN Users u ON r.user_id = u.user_id
JOIN Drivers d ON r.driver_id = d.driver_id
WHERE r.status = 'completed';

SELECT r.*, d.driver_name, d.rating
FROM Rides r
JOIN Drivers d ON r.driver_id = d.driver_id
WHERE d.rating > 4.5;

SELECT r.*, p.payment_method
FROM Rides r
JOIN Payments p ON r.ride_id = p.ride_id
WHERE p.payment_method = 'Cash';

SELECT r.ride_id,
       u.user_name,
       d.driver_name,
       u.city
FROM Rides r
JOIN Users u ON r.user_id = u.user_id
JOIN Drivers d ON r.driver_id = d.driver_id
WHERE u.city = d.city;

SELECT r.ride_id,
       r.status,
       p.payment_status
FROM Rides r
JOIN Payments p ON r.ride_id = p.ride_id
WHERE r.status = 'completed'
AND p.payment_status = 'failed';

SELECT DISTINCT u.user_id,
       u.user_name
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
WHERE r.fare > 500;

## SELECT + WHERE + GROUP BY ##

SELECT u.user_id, u.user_name, COUNT(r.ride_id) AS total_rides
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
HAVING COUNT(r.ride_id) > 2;

SELECT d.driver_id, d.driver_name, SUM(r.fare) AS total_earnings
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.driver_name
HAVING SUM(r.fare) > 1000;

SELECT u.city, AVG(r.fare) AS avg_fare
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
GROUP BY u.city
HAVING AVG(r.fare) > 150;

SELECT ride_date, COUNT(*) AS total_rides
FROM Rides
GROUP BY ride_date
HAVING COUNT(*) > 5;

SELECT u.user_id, u.user_name,
       SUM(r.distance_km) AS total_distance
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
HAVING SUM(r.distance_km) > 50;

SELECT payment_method,
       COUNT(*) AS usage_count
FROM Payments
GROUP BY payment_method
HAVING COUNT(*) > 2;


SELECT city,
       COUNT(*) AS total_users
FROM Users
GROUP BY city
HAVING COUNT(*) > 10;

SELECT driver_id, driver_name, rating
FROM Drivers
WHERE rating > 4.2;

## SELECT + ORDER BY + LIMIT ##

SELECT *
FROM Rides
ORDER BY fare DESC
LIMIT 5;

SELECT *
FROM Rides
ORDER BY distance_km ASC
LIMIT 3;

SELECT *
FROM Drivers
ORDER BY rating DESC
LIMIT 3;

SELECT *
FROM Rides
ORDER BY fare DESC
LIMIT 1,1;

## SELECT + SUBQUERIES ##

SELECT *
FROM Rides
WHERE fare >
(
    SELECT AVG(fare)
    FROM Rides
);

SELECT *
FROM Users
WHERE user_id NOT IN
(
    SELECT DISTINCT user_id
    FROM Rides
);

SELECT *
FROM Drivers
WHERE driver_id NOT IN
(
    SELECT DISTINCT driver_id
    FROM Rides
    WHERE status = 'completed'
);

SELECT *
FROM Rides
WHERE fare =
(
    SELECT MAX(fare)
    FROM Rides
);

SELECT d.driver_id,
       d.driver_name,
       SUM(r.fare) AS total_earning
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY total_earning DESC
LIMIT 1 OFFSET 1;

SELECT *
FROM Rides r1
WHERE fare >
(
    SELECT AVG(r2.fare)
    FROM Rides r2
    WHERE r1.user_id = r2.user_id
);

SELECT u.user_id,
       u.user_name
FROM Users u
JOIN Rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
HAVING COUNT(r.ride_id) = 1;

## UPDATE / DELETE ##

UPDATE Rides r
JOIN Payments p
ON r.ride_id = p.ride_id
SET r.status = 'completed'
WHERE p.payment_status = 'success';

DELETE FROM Rides
WHERE status = 'cancelled'
AND fare = 0;

UPDATE Drivers
SET rating = 3
WHERE rating < 3;

SELECT * FROM Rides;
SELECT * FROM Drivers;

DELIMITER $$

CREATE PROCEDURE GetUserRidesByFare(
    IN p_user_id INT,
    IN p_fare DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM Rides
    WHERE user_id = p_user_id
      AND fare > p_fare;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetDriversByRating(
    IN p_rating DECIMAL(3,2)
)
BEGIN
    SELECT *
    FROM Drivers
    WHERE rating > p_rating;
END $$

DELIMITER ;