-- List the databases
SELECT datname FROM pg_database;
-- Show current database
SELECT current_database();
-- Create a database
CREATE DATABASE database_name;
-- Drop a database
DROP DATABASE database_name;
-- Default schemas in Postgres which are at a database level
-- I.e each database has the information about it stored in the following schemas.
-- Schemas here are like folders
-- public, information_schema, pg_catalog
-- information_schema -> a folder that holds information about tables, views and columns
-- List the tables in the current database
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';
-- Information Schema Databse select the "tables" table
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