--Combining Tables 
CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

--Making sure both tables contains same ammount of Unique apps
SELECT COUNT(DISTINCT id) AS app_ids FROM appleStore_description_combined
SELECT COUNT(DISTINCT id) AS app_ids  FROM AppleStore


--Checking for missing values in key fields
SELECT COUNT(*) AS anymissingvalues FROm AppleStore
WHERE track_name ISNULL or user_rating ISNULL

SELECT COUNT(*) AS anymissingvalues FROm appleStore_description_combined
WHERE track_name ISNULL or app_desc ISNULL



--Number of apps per genra---Games and Entertainment has the highest apps
SELECT prime_genre, COUNT(*) as total_num_per_genra FROM AppleStore
GROUP By prime_genre
ORDER BY total_num_per_genra DESC


--Overview of apps rating 
SELECT MIN(user_rating) as min_number_rating, 
AVG(user_rating) as avg_number_rating, 
Max(user_rating) as max_number_rating
FROM AppleStore

--Avg app price by genra---Medical and Business apss has highest avg price
SELECT  prime_genre, AVG(price)
FROM AppleStore GROUP BY prime_genre ORDER BY AVG(price) DESC

---which type of genra are free and paid
SELECT prime_genre,
CASE WHEN  price >0 THEN 'PAID' ELSE 'FREE' END AS Price_type FROM AppleStore
GROUP BY prime_genre




--determing whether paid or free app has better avg rating--paid app has better ratings

SELECT 
CASE WHEN  price >0 THEN 'PAID' ELSE 'FREE' END AS Price_type,  AVG(user_rating) AS avg_rating FROM AppleStore
GROUP BY price_type

---determing if number of language support has any impact on app rating-- 10-30 highest, >30 next, <10 lowest

SELECT 
CASE
WHEN lang_num<10 Then '<10'
WHEN lang_num BETWEEN 10 AND 30 THEN 'Between 10-30' 
ELSE  '>30'
END AS lang_range,
AVG(user_rating) AS avg_rating FROM AppleStore
GROUP BY lang_range
ORDER BY avg_rating DESC

---determing genra with low rating---Finance and books

SELECT prime_genre AS list_of_genra, AVG(user_rating) as avg_user_rating FROM AppleStore
GROUP BY prime_genre
ORDER BY avg_user_rating LIMIT 10

---correaltion between app description length and rating--long highest, medium, short

SELECT 
CASE 
WHEN LENGTH(appleStore_description_combined.app_desc)<500 THEN 'Short'
WHEN LENGTH(appleStore_description_combined.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
ELSE 'Long' END as app_des_size ,
AVG(AppleStore.user_rating) as avg_user_rating
FROm AppleStore
INNER JOIN appleStore_description_combined on AppleStore.id = appleStore_description_combined.id
GROUP BY app_des_size
ORDER BY avg_user_rating DESC

--top rated genra---productivity and music 

SELECT prime_genre, AVG(user_rating) as avg_user_rating FROM AppleStore
GROUP BY prime_genre
ORDER BY avg_user_rating DESC

--top rated apps for each genra


SELECT prime_genre, track_name, user_rating
FROM(
  SELECT prime_genre, track_name,user_rating,
  RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  FROM AppleStore
  ) As a
WHERE a.rank = 1


--final recommendations---
--1. paid apps have better ratings
--2. app provides language support between 10-30 has better ratings.
--3. finance and book apps has lower ratings.
--4. apps with longer description has better ratings
--5. Productivity and Music are the higest avg rated genra
--6. new apps should aim for avg 3.5 rating or higher.
--7. game and entertainment have highest amount of apps.
--8. Medical and buisness apps has the highest avg app price.