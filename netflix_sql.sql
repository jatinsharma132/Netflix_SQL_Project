 -- netflix project

 create table netflix(
show_id varchar(10),
type varchar(20),
title varchar(150),
director varchar(250),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year  int ,
rating varchar (10),
duration varchar(15),
listed_in varchar(100),
description varchar(250));

 select * from netflix;

 -- q1. Count the number of Movies vs TV Shows

select type ,count(*) as total
from netflix
group by type;
 


-- Q2.Find the most common rating for movies and TV shows

SELECT type, rating
FROM (
    SELECT type, rating, 
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix
    GROUP BY type, rating
) ranked
WHERE rnk = 1;


 -- Q3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where type = 'Movie'and release_year =2020;

-- 4. Find the top 5 countries with the most content on Netflix

select 
   unnest(string_to_array(country,',')) as top_5,
   count(show_id) as total_content
   from netflix
   group by top_5
   order by total_content desc
   limit 5;


-- Q5. Identify the longest movies

select * from netflix 
where type = 'Movie'
and duration = (select max(duration)from netflix)
order by duration 


-- 6. Find content added in the last 5 years

select * from netflix 
where to_date(date_added,'month DD,YYYY') >= current_date - interval '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *  
from netflix
where director like '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

select *
from netflix
where type = 'TV Show'
and split_part(duration,' ',1) :: numeric >5

-- 9. Count the number of content items in each genre

select 
unnest(string_to_array(listed_in,','))as each_genre,
count(show_id)as total_count
from netflix
group by each_genre

-- 10.Find each year and the average numbers of content release in India on netflix. 

select 
   extract(year from  to_date(date_added,'Months DD , YYYY')) as year,
   count(*)as yearly_content,
   round(count(*)::numeric/(select count(*) from netflix  where country = 'India'):: numeric *100
   ,2) as avg_content_per_year
   from netflix
  where country = 'India'
  group by year
  order by yearly_content desc
  limit 5 ;


-- 11. List all movies that are documentaries
select *,
unnest(string_to_array(listed_in,',')) as genre
from netflix
where listed_in ilike '%Documentaries%'
and type = 'Movie'	 

-- 12. Find all content without a director

select * from netflix 
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where release_year>extract(year from current_date)-10
and casts ilike  '%Salman Khan%'

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

select 
unnest(string_to_array(casts,','))as actors,
count(*) as total_number
from netflix
where country ilike '%India%'
group by actors
order by total_number desc
limit 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


with new_table as (
select * ,
case
when description ilike '%kill%'
or description ilike '%violence%' then 'Bad_Content'
else 'Good_Content'
end category 
from netflix)

select category , count(*)as total_content
from new_table
group by category;




select * from netflix




   