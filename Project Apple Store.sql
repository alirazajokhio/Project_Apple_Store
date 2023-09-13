Create table appleStore_description_combined AS

select * from appleStore_description1

union ALL

SELECT * from appleStore_description2

union ALL

SELECT * from appleStore_description3

union ALL

select * from appleStore_description4


**Exploratory Data Analysis**

-- check the number of unique apps in both tablesAppleStpore 

SELECT count(DISTINCT id) as UniqueAppIDs
From AppleStore

SELECT count(DISTINCT id) as UniqueAppIDs
FROM appleStore_description_combined


--Check for any missing values in key fields 

select count (*) as MissingValues
From AppleStore
where track_name is null or user_rating is null or prime_genre is NULL


select count (*) as MissingValues
From appleStore_description_combined
where app_desc is null



--Find out the number of apps per genre 

select prime_genre, count(*) AS NumApps
from AppleStore
Group by prime_genre
order by NumApps DESC


--Get an overview of the apps' ratingsAppleStore

SELECT min(user_rating) as MinRating,
       max(user_rating) As MaxRating,
       avg(user_rating) as AvgRating
From AppleStore

-- Determine whether paid apps have higher ratings than free appsAppleStore

select CASE
          when price > 0 then 'Paid'
          else 'Free'
        End as App_Type,
        avg(user_rating) as Avg_Rating
From AppleStore
Group by App_Type


--check if apps with more supported language have higher ratings 


select CASE
           When lang_num < 10 then '<10 languages'
           When lang_num BETWEEN 10 and 30 then'10-30 language'
           else '>30 language'
        End as language_bucket,
        avg(user_rating) As  Avg_Rating
From AppleStore
group by language_bucket
order by Avg_Rating DESC


--check genre with low ratings 

select prime_genre,
       avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
LIMIT 10


--check if there is correlation between the lenght of the app description and the user rating 

select CASE
           when length(b.app_desc) <500 then 'short'
           when length(b.app_desc) between 500 and 1000 then 'medium'
           else 'Long'
      End as description_length_bucket,
      avg(a.user_rating) as average_rating
        
from 
    AppleStore as A 
join 
    appleStore_description_combined as b 
    
 on 
      a.id = b.id 
      
Group by description_length_bucket
order by average_rating desc


--check the top_rated apps for each genre  


select 
     prime_genre,
     track_name,
     user_rating
from (
      SELECT
      prime_genre,
      track_name,
      user_rating,
      Rank() Over(PARTITION BY prime_genre order by user_rating desc, rating_count_tot DESC) as rank
      FROM
      AppleStore
      ) as a 
 where 
  
a.rank = 1
     