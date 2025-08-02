--NETFLIX PROJECT

DROP TABLE IF EXISTS netflix;
CREATE TABLE Netflix (
	show_id VARCHAR(7),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210),
	casts VARCHAR(750),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating  VARCHAR(10),
	duration VARCHAR(20),
	listed_in VARCHAR(85),
	description VARCHAR(250)
);

select * from netflix 

SELECT
	COUNT(*) as total_rows
FROM netflix;

--1. Count number of movies vs TV shows

SELECT 
	type,COUNT(*) as total_contents 
FROM netflix
GROUP BY 1;

--2. Find the most common rating for movies and TV shows

SELECT 
	type,
	rating,
	count_of_rating
FROM 
(
SELECT
	type,
	rating,
	COUNT(*) as count_of_rating,
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC ) AS ranking  
FROM netflix 
GROUP BY 1,2
)
WHERE ranking=1


--3. List all movies released in a specific year (e.g., 2020)

SELECT 
	* 
FROM netflix
WHERE type='Movie' and release_year=2003



--4. Find the top 5 countries with the most content on Netflix


SELECT 
	UNNEST(STRING_TO_ARRAY(Country,',')),
	COUNT(show_id)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--5. Identify the longest movie

SELECT * 
FROM netflix
WHERE duration = (SELECT max(duration) from netflix WHERE type='Movie')

--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added ,'Month DD,YYY')>= CURRENT_DATE - INTERVAL '5 years';



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%' 

--8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE
	 type='TV Show' AND
	SPLIT_PART(duration,' ',1)::numeric>5 

--9. Count the number of content items in each genre


SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,COUNT(Show_id)
FROM netflix
GROUP BY 1



--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!


SELECT release_year,
ROUND(COUNT(show_id)::numeric/(SELECT COUNT(show_id) FROM netflix where country='India')::numeric *100,2) as average
FROM netflix
WHERE country ='India'
GROUP BY release_year
ORDER BY 2 DESC
LIMIT 5



--11. List all movies that are documentaries

SELECT 
	title,listed_in 
FROM 
	netflix
WHERE 
	type='Movie'
 	AND
 	listed_in ILIKE '%Documentaries%'


--12. Find all content without a director

SELECT * FROM netflix
WHERE director is NULL



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * 
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND
  release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT
	UNNEST(STRING_TO_ARRAY(casts,',')), COUNT(*) 
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

SELECT Remark as Category, COUNT(*)
FROM(
SELECT * ,
	CASE
	WHEN description ILIKE '%kill%' 
	OR
	description ILIKE '%violence%' THEN 'Bad'
	ELSE 'Good'
	END
	as Remark
	FROM netflix
)
GROUP BY 1


