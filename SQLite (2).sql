CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

-- check the number of unique apps in both tableAppleStoreappleStore_description1

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

-- returned 7197 IDs

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

-- this returned 7197 IDs as well

-- Now checking missing valuesAppleStore

SELECT count(*) AS MissingValues
FROm AppleStore
WHERE track_name IS NULL
	or user_rating is NULL
    or prime_genre is NULL
    
-- returned 0 missing values

SELECT count(*) AS MissingValues
FROm appleStore_description_combined
WHERE app_desc IS NULL

-- 2nd table also doesn't have any missing valuesAppleStore

-- Finding out the number of apps per genre/ most popular genre

SELECT prime_genre, COUNT(*) AS NumberOfApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumberOfApps DESC

-- Get an overview of apps' ratings

SELECT min(user_rating) AS MinimumRating,
	   max(user_rating) AS MaximumRating,
       avg(user_rating) AS AverageRating
FROM AppleStore


**DATA ANALYSIS**

--Determine if paid apps have higher ratings than free appsAppleStore

SELECT case
			when price > 0 then 'Paid'
            else 'Free'
       end as App_Type,
       avg(user_rating) as Average_Rating
FROM AppleStore
GROUP BY App_Type

-- Paid Apps have slightly higher average ratings

-- Check if apps with more supported languages have higher ratingsAppleStore

SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS AverageRating
FROM AppleStore
GROUP BY language_bucket
ORDER by AverageRating DESC

-- Apps with language support between 10 and 30 have higher average ratings than others.

-- Checking genres with lower ratingsAppleStore

SELECT prime_genre,
		avg(user_rating) AS AverageRating
FROM AppleStore
GROUP BY prime_genre
ORder By AverageRating
LIMIT 10

-- Looks like Catalogs, Finance and Book have ratings at 2.5 or lower, so people are not satisfied with what are on offer. So, there is an opportunity in those genre to create and app.AppleStore

-- Check if there is correlation between the length of the app description and the user ratingAppleStore
SELECT CASE
			when length(b.app_desc) < 500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 and 1000 THEN 'Medium'
            ELSE 'Long'
       END AS Description_Length_bucket,
       avg(user_rating) AS Average_rating

FROM
	AppleStore AS A
JOIN
	appleStore_description_combined AS B
ON
	A.id = B.id
GROUP BY Description_Length_bucket
ORDER BY Average_rating DESC

-- We see that the longer the description the higher average ratingAppleStore

-- Check the top-rated apps for each genre

SELECT
	prime_genre,
    track_name,
    user_rating
FROM
	(
      SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM AppleStore
      ) AS a
WHERE a.rank = 1

-- RECOMMENDATIONS

-- Paid apps have better ratings
-- Apps with language support between 10 and 30 have higher average ratings than others.
-- Looks like Catalogs, Finance and Book have ratings at 2.5 or lower, so people are not satisfied with what are on offer. So, there is an opportunity in those genre to create and app.AppleStore
-- We see that the longer the description the higher average ratingAppleStore
        