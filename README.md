# Netflix Data ETL Pipeline Project

This project demonstrates the development of an end-to-end data engineering solution that automates data ingestion, transformation, and storage in a PostgreSQL database, with the ability to perform analytics using pgAdmin. It follows a modular monolithic architecture, where PostgreSQL and pgAdmin are decoupled into separate containers but orchestrated together using Docker Compose. This approach leverages containerization for ease of setup and management, while maintaining tight integration, making it suitable for smaller-scale data engineering solutions.

## Project Overview
The pipeline is designed to showcase key data engineering skills such as data extraction, transformation, and loading (ETL). It uses containerized services (PostgreSQL and pgAdmin) to ensure a portable and easy-to-setup environment. Data is pulled from a public Netflix dataset available on Kaggle, loaded into a PostgreSQL database, and made available for querying and analysis through pgAdmin. The pipeline is built using Docker to create an isolated environment for running and managing services.

## Features
- **Automated Data Ingestion**: The data is processed and loaded into the PostgreSQL database using SQL procedures and a Bash script.
- **Containerized Architecture**: PostgreSQL and pgAdmin run as containers, providing easy portability and setup.
- **Data Transformation**: SQL scripts handle data cleaning and transformation as part of the loading process.
- **pgAdmin Integration**: After the data is loaded, pgAdmin provides a user-friendly interface to query and explore the Netflix dataset.
- **Easy Deployment**: The entire pipeline can be deployed with a few simple commands, making it reproducible and scalable.

## ETL Process

### 1. Extraction
- **Data Source**: The raw data is obtained from the Netflix dataset available on [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download) in CSV format.
- **Data Format**: The dataset is packaged in a `archive.zip` file, which contains the `netflix_titles.csv` file.

### 2. Transformation
- **Data Cleaning**: Before loading, the SQL script ensures that any existing `netflix_shows` table is dropped, preventing conflicts.
- **Data Structure**: A new `netflix_shows` table is created with appropriate data types for each field, including:
  - `show_id`: varchar(10) (Primary Key)
  - `show_type`: varchar(20)
  - `title`: varchar(255)
  - `director`: varchar(255)
  - `show_cast`: text
  - `country`: varchar(255)
  - `date_added`: date
  - `release_year`: int
  - `rating`: varchar(10)
  - `duration`: varchar(50)
  - `listed_in`: text
  - `show_description`: text

### 3. Loading
- **Data Insertion**: The `COPY` command in the SQL script is used to load data from the `netflix_titles.csv` file directly into the `netflix_shows` table. This method is efficient and allows for bulk loading of data.

## Load Pipeline
* Fork this repo and open it in GitCodespace ([Steps here](./Documentation.md#setting-up-git-codespace-instance)) using VSCode or clone the repo on your local system (ensure you have all the required applications installed - [See here](./Documentation.md#application-installation)).
* Download the data:
    * On your host machine, download the data in `archive.zip` format manually from [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download).
    * Drag and drop the file into the [data folder](./data) of the Codespace instance in VSCode from your host machine.
* Run the following commands in the GitCodespace server's terminal:
```bash
    make up # Starts the containers
    make load-data # Populates the pgAdmin tables with the Netflix data
```
* Go to the `PORTS` tab in VSCode and click on the URL.
* Log into pgAdmin to view the Netflix database (Steps here - [Look at Point 4](./Documentation.md#running-the-containers)).
* You can now perform preliminary analysis in pgAdmin using PSQL.
* To shut down the containers, run the following commands in the GitCodespace server's terminal:
```bash
    make down
    make clean-slate
```

## Key Files and Directories
* [Documentation.md](./Documentation.md): Contains the project documentation.
* [Dockerfile](./Dockerfile): This Dockerfile does the following:
    * Creates a container using the PostgreSQL database image.
    * Sets `/data` as the working directory in the container.
    * Copies all the files in the `data` folder on the local system into the `data` folder in the container.
    * Runs commands to update and upgrade `apt-get`, unzip `archive.zip`, and change the permissions for the other files in `data` to 777.
* [docker-compose.yml](./docker-compose.yml): A YAML file that starts two services (as containers) with named mounting:
    1. PostgreSQL: Builds the PostgreSQL container from the Dockerfile.
    2. pgAdmin.
* [data folder](./data/): Contains data-related files:
    * `archive.zip` - Raw data downloaded from Kaggle.
    * [load_data](./data/load_data): SQL script to create a procedure called `load_data()` that:
        * Drops the `netflix_shows` table if it exists.
        * Creates a new `netflix_shows` table.
        * Loads data from the `.csv` file into the newly created table.
    * [load](./data/load): Bash script that runs `psql` commands on the `netflix` database to:
        1. Run the script in `load_data.sql` to create the `load_data()` procedure.
        2. Run the command to call the `load_data()` procedure.
* [Makefile](./Makefile): Contains commands to:
    * `up`: Starts the containers
    * `load-data`: Loads the data into the PostgreSQL container using the `docker exec` command.
    * `down`: Stops the containers.
    * `clean-slate`: Deletes the containers, volumes, and images.
* [queries folder](./queries/): Contains the queries run in pgAdmin. This data is stored in the pgAdmin volume mounted at `/var/lib/docker/volumes/pgadmin_data/_data/storage/admin_admin.com/eda_queries.sql`.