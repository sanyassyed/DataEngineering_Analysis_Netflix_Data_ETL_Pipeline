-- SECTION 1: Basic Database commands
SELECT * FROM pg_database;
-- pg_database is a system catalog that stores metadata about the databases in your PostgreSQL instance. It is essentially a system table that holds information about each database managed by the PostgreSQL server.

-- List the databases
SELECT datname FROM pg_database;
-- Show current database
SELECT current_database();
-- Create a database
CREATE DATABASE database_name;
-- Drop a database
DROP DATABASE database_name;

/* What is a default schema?
 * Default schemas in Postgres are at a database level
 * I.e each database has information about it stored in the following schemas. (NOTE: Schemas here are like folders)
 * public, information_schema, pg_catalog
 * information_schema -> a folder that holds information about tables, views and columns
 * information_schema, public schema & pg_catalog schema is database-specific: It only shows metadata for the database you are connected to.
*/

-- List the tables in the current database
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Exploring Information Schema 
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.views;
SELECT * FROM information_schema.columns;

-- View all the columns in the netflix database
SELECT * 
FROM information_schema.columns
WHERE table_schema = 'public';

-- View all the tables in information_schema db
SELECT table_name
FROM   information_schema.tables
WHERE  table_schema = 'information_schema';

----------------------------------------------------
----------------------------------------------------
-- SECTION 2: Beginner Level Queries

-- Check current database
SELECT current_database();

-- Sample Data
SELECT * 
FROM netflix_shows 
LIMIT 15;

-- DISTINCT VALUES
SELECT COUNT(DISTINCT show_id)
FROM netflix_shows;

SELECT COUNT(DISTINCT show_type)
FROM netflix_shows;

-- Count for entire data
SELECT COUNT(*)
FROM netflix_shows;

-- Display how many shows are availabe with rating TV-PG: 863
SELECT COUNT(*) shows_with_tv_pg_rating
FROM   netflix_shows
WHERE  rating iLIKE '%TV-PG%';

-- Display how many TV shows and Movies are in the dataset 6131 2676
-- Exploratory query
SELECT COUNT(*)
FROM   netflix_shows
WHERE  show_type IN ('Movie', 'TV Show');

-- Option 1
SELECT show_type,
       COUNT(*) total_shows
FROM   netflix_shows
GROUP BY show_type;

-- Option 2
SELECT SUM(CASE WHEN show_type = 'Movie' THEN 1 ELSE 0 END) total_movies,
       SUM(CASE WHEN show_type = 'TV Show' THEN 1 ELSE 0 END) total_tvshows 
FROM   netflix_shows;

-- Check result
SELECT 6131 + 2676;

-- Show all the Reality TV series 255
SELECT *
FROM   netflix_shows
WHERE  listed_in iLIKE '%Reality TV%';

-- Show 90s kid's movies 24

-- Exploratory query
SELECT MAX(release_year),
       MIN(release_year)
FROM   netflix_shows;

SELECT title
FROM   netflix_shows
WHERE  show_type iLike 'Movie' AND
	   listed_in iLike '%children%' AND
	   release_year BETWEEN 1990 AND 2000;

-- Shows 90s Kid's movie which has length less 2 hours (100 minutes)
-- Order by increasing duration 20

-- Option 1
SELECT title, 
       show_type,
	   listed_in,
	   release_year,
       split_part(duration, ' ', 1)::integer duration_in_mins
FROM   netflix_shows
WHERE  show_type iLike 'Movie' AND
       listed_in iLike '%children%' AND
       release_year BETWEEN 1990 AND 2000 AND 
	   CAST(split_part(duration, ' ', 1) AS INTEGER) < 100
ORDER BY 2 ASC;	 

-- Option 2
SELECT title, 
	   duration, 
	   SUBSTRING(duration,0, POSITION(' ' in duration)) duration_int
FROM   netflix_shows
WHERE  show_type='Movie' AND 
       listed_in LIKE '%Children%' AND 
	   release_year BETWEEN 1990 AND 2000 AND 
	   CAST(SUBSTRING(duration,0, POSITION(' ' in duration)) as BIGINT) < '100'
ORDER BY duration_int ;

-- Show all available Jaws movie based on the released year 4
SELECT title,
       release_year
FROM netflix_shows
WHERE show_type = 'Movie' AND
      title iLike '%jaws%'
ORDER BY 2;

--------------------------------------------------------
--------------------------------------------------------
-- SECTION 3: Intermediate Level Queries

-- Show all the Reality TV series or Horror series released in last 3 years 72
SELECT title,
       listed_in,
	   release_year,
	   show_type
FROM netflix_shows
WHERE LOWER(listed_in) SIMILAR TO '%(reality%tv|horror)%' AND
      release_year BETWEEN (extract(YEAR from CURRENT_DATE)-3) AND (extract(YEAR from CURRENT_DATE)) ;

-- Show all the Reality TV series and Horror series released in last 3 years 2
SELECT title,
       listed_in,
	   release_year
FROM netflix_shows
WHERE listed_in iLIKE '%reality%tv%' AND
      listed_in iLIKE '%horror%' AND
	  release_year BETWEEN (EXTRACT(YEAR FROM CURRENT_DATE)-3) AND (EXTRACT(YEAR FROM CURRENT_DATE));

-- Show TV shows and movies where director acted in the movie 
-- and based out of United States 119
SELECT title,
       director,
	   show_cast, 
	   country
FROM netflix_shows
WHERE show_cast ILIKE '%'||director||'%' AND
      country ILIKE '%united states%'
ORDER BY 1; 

SELECT title,
       director,
	   show_cast, 
	   country
FROM netflix_shows
WHERE country ILIKE '%united states%' AND
      LOWER(director) IN (
  							SELECT trim(both ' ' FROM UNNEST(string_to_array(LOWER(show_cast), ',')))
                          )
ORDER BY 1;

-- regular expression: ~ ('(^|, )' || director || '($|, )');


-- Show directors who are also actors 
-- and worked in different movie 67
SELECT DISTINCT(director)
FROM netflix_shows
WHERE director IN (SELECT DISTINCT UNNEST(string_to_array((SELECT STRING_AGG(show_cast, ',') actors FROM netflix_shows), ',')
									      )
				   ) AND
	  LOWER(director) NOT IN (
  							SELECT trim(both ' ' FROM UNNEST(string_to_array(LOWER(show_cast), ',')))
                          ); 

--------------------------------------------------------------------
--------------------------------------------------------------------
-- SECTION 4: Advance Level Queries

-- Top 3 director who worked as actor and director in most movies
-- Omoni, Yilmaz, Clint
-- Option 1
SELECT director,
       COUNT(*) total_movies
FROM netflix_shows
WHERE LOWER(director) IN (
					SELECT trim(both ' ' FROM UNNEST(string_to_array(LOWER(show_cast), ',')))
					)
GROUP BY director
ORDER BY 2 DESC
LIMIT 3;

-- Option 2
WITH director_actor 
AS (
	SELECT director,
	       COUNT(*) total_movies
	FROM netflix_shows
	WHERE LOWER(director) IN (
						SELECT trim(both ' ' FROM UNNEST(string_to_array(LOWER(show_cast), ',')))
						)
	GROUP BY director
	ORDER BY 2 DESC
	),
ranked_directors 
AS (
	SELECT director,
	       total_movies,
		   RANK() OVER (ORDER BY total_movies DESC) rnk
	FROM director_actor
	)
SELECT * 
FROM ranked_directors
WHERE rnk <= 3;

-- Least 3 years where any TV show or movie is uploaded
-- 2008-2, 2009-2, 2010-1 
SELECT EXTRACT(YEAR FROM date_added) year_added,
       COUNT(title)
FROM netflix_shows
WHERE date_added IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_added)
ORDER BY 2 ASC
LIMIT 3;


-- What is the average duration of movies and the average number of seasons for TV shows?
-- Movie 99.58 TV Show 1.76
-- Option 1
SELECT show_type,
       CAST(ROUND(AVG(CAST(split_part(duration, ' ', 1) AS INTEGER)), 2) AS TEXT) || CASE WHEN show_type = 'Movie' THEN ' minutes' ELSE ' Seasons' END average_duration
FROM netflix_shows
WHERE duration IS NOT NULL
GROUP BY show_type;

-- What are the top 3 most popular genres in each country based on the number of Netflix shows, using a dense rank to break ties?
-- 418 rows

SELECT * FROM netflix_shows
LIMIT 3;

WITH country_unnest_tbl
AS (
	SELECT show_id,
		   TRIM (BOTH ' ' FROM UNNEST (string_to_array(LOWER(country), ','))) country_single
	FROM netflix_shows
	WHERE country IS NOT NULL
	),
genre_unnest_tbl
AS (
	SELECT show_id,
	       TRIM (BOTH ' ' FROM UNNEST (STRING_TO_ARRAY(LOWER(listed_in), ','))) genre
	FROM netflix_shows
	WHERE listed_in IS NOT NULL
	),
grouped_tbl
AS (
SELECT 
       c.country_single country,
	   g.genre genre,
	   COUNT(*) total_shows
FROM country_unnest_tbl c,
     genre_unnest_tbl g
WHERE c.show_id = g.show_id AND
      c.country_single <> '' AND
	  genre <> ''
GROUP BY 
         c.country_single,
		 g.genre),
ranked_tbl 
AS 
	(SELECT country,
	       genre,
		   total_shows,
		   DENSE_RANK() OVER (PARTITION BY country ORDER BY total_shows DESC) top_genre_ranking
	FROM grouped_tbl
	)
SELECT * 
FROM ranked_tbl
WHERE top_genre_ranking <= 3;

