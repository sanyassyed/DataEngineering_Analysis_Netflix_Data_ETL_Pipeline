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
SELECT * FROM information_schema.columns
WHERE table_schema = 'public';

-- View all the tables in information_schema db
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'information_schema';

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

-- Display how many shows are availabe with rating TV-PG
SELECT COUNT(*) shows_with_tv_pg_rating
FROM netflix_shows
WHERE rating iLIKE '%TV-PG%';

-- Display how many TV shows and Movies are in the dataset
-- Exploratory query
SELECT COUNT(*)
FROM netflix_shows
WHERE show_type IN ('Movie', 'TV Show');

-- Option 1
SELECT show_type,
       COUNT(*) total_shows
FROM netflix_shows
GROUP BY show_type;

-- Option 2
SELECT SUM(CASE WHEN show_type = 'Movie' THEN 1 ELSE 0 END) total_movies,
       SUM(CASE WHEN show_type = 'TV Show' THEN 1 ELSE 0 END) total_tvshows 
FROM netflix_shows;

-- Check result
SELECT 6131 + 2676;

-- Show all the Reality TV series
SELECT *
FROM netflix_shows
WHERE listed_in iLIKE '%Reality TV%';

-- Show 90s kid's movies

-- Exploratory query
SELECT MAX(release_year),
       MIN(release_year)
FROM netflix_shows;

SELECT title
FROM netflix_shows
WHERE show_type iLike 'Movie' AND
	  listed_in iLike '%children%' AND
	  release_year BETWEEN 1990 AND 2000;

-- Shows 90s Kid's movie which has length less 2 hours (100 minutes)
-- Order by increasing duration

-- Option 1
SELECT title, 
       show_type,
	   listed_in,
	   release_year,
       split_part(duration, ' ', 1)::integer duration_in_mins
FROM netflix_shows
WHERE show_type iLike 'Movie' AND
      listed_in iLike '%children%' AND
      release_year BETWEEN 1990 AND 2000 AND 
	  CAST(split_part(duration, ' ', 1) AS INTEGER) < 100
ORDER BY 2 ASC;	 

-- Option 2
SELECT title, 
	   duration, 
	   SUBSTRING(duration,0, POSITION(' ' in duration)) duration_int
FROM netflixshows
WHERE show_type='Movie' AND 
      listed_in LIKE '%Children%' AND 
	  release_year BETWEEN 1990 AND 2000 AND 
	  CAST(SUBSTRING(duration,0, POSITION(' ' in duration)) as BIGINT) < '100'
ORDER BY duration_int ;

-- Show all available Jaws movie based on the released year
SELECT title,
       release_year
FROM netflix_shows
WHERE show_type = 'Movie' AND
      title iLike '%jaws%'
ORDER BY 2;

--------------------------------------------------------
--------------------------------------------------------
-- SECTION 3: Intermediate Level Queries

-- Show all the Reality TV series or Horror series released in last 3 years
SELECT title,
       listed_in,
	   release_year,
	   show_type
FROM netflix_shows
WHERE LOWER(listed_in) SIMILAR TO '%(reality%tv|horror)%' AND
      release_year BETWEEN (extract(YEAR from CURRENT_DATE)-3) AND (extract(YEAR from CURRENT_DATE)) ;

-- Show all the Reality TV series and Horror series released in last 3 years
SELECT title,
       listed_in,
	   release_year
FROM netflix_shows
WHERE listed_in iLIKE '%reality%tv%' AND
      listed_in iLIKE '%horror%' AND
	  release_year BETWEEN (EXTRACT(YEAR FROM CURRENT_DATE)-3) AND (EXTRACT(YEAR FROM CURRENT_DATE));

-- Show TV shows and movies where director acted in the movie and based out of United States
SELECT title,
       director,
	   show_cast, 
	   country
FROM netflix_shows
WHERE show_cast ILIKE '%'||director||'%' AND
      country ILIKE '%united states%'; --119

SELECT title,
       director,
	   show_cast, 
	   country
FROM netflix_shows
WHERE country ILIKE '%united states%' AND
      director IN ()
	  
-- Show directors who are also actors 
-- and worked in different movie
SELECT DISTINCT(director)
FROM netflix_shows
WHERE director IN (SELECT DISTINCT UNNEST(string_to_array((SELECT STRING_AGG(show_cast, ',') actors 
						                          FROM netflix_shows
												  ), ','
												  )
									)
					) AND
	  show_cast NOT ILIKE '%'||director||'%'; 

WITH dir AS 
(
SELECT 
distinct director, title
FROM netflix_shows ns 
WHERE director <>''
)
SELECT 
DISTINCT 
d.director AS director_actor, a.title, a.show_cast
FROM dir d, netflix_shows a
WHERE (A.show_cast LIKE '%'|| D.director||',%' OR A.show_cast LIKE '%, '||D.director)
AND a.director <> d.director
AND a.title<>d.title
AND a.show_cast<>''
AND a.title <> ''
LIMIT 100;