# Netflix
* Data Pipeline to Pull and Analyze Netflix Dataset
* Project documentation [here](./Documentation.md)

## Load Pipeline
* Fork this repo and open it in GitCodespace ([Steps here](./Documentation.md#setting-up-git-codespace-instance)) using VSCode or clone the repo on your local system (make sure you have all the required applications installed on your local system - [Look here](./Documentation.md#application-installation))
*  Download the data:
    * On your host machine download the data in `archive.zip` format manually from [here](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download).
    * Drag and drop the file into the [data folder](./data) of codespace instance on VSCode from the host machine.
* Run the following commands in the Gitcodespace server's terminal
```bash
    make up #starts the cotainers
    make load-data # populates the pgadmin tables with the flight data
```
* Goto the `PORTS` tab in VSCode and click on the URL
* Log into PgAdmin to view the netflix database (Steps here- [Look at Point 4](./Documentation.md#running-the-containers))
* You can now perform preliminary analysis in PgAdmin using PSQL
* To Shutdown the containers run the following commands in the Gitcodespace server's terminal
```bash
    make down
    make clean-slate
```

## ImportantFiles
* [Documentation.md](./Documentation.md) : contains the project documentation
* [Dockerfile](./Dockerfile): this docker file does the following
    * Creates a container using the postgres db image
    * Sets `/data` as the working directory in the container
    * Copies all the files in the `data` folder on the local system into the `data` folder on the container
    * runs commands on to update and upgrade apt-get, unzip archive.zip and change the permissions for the other files in data to 777
* [docker-compose.yml](./docker-compose.yml): yml file that starts 2 containers using volume mounting
    1. Postgres: Builds the postgres container from the Dockerfile
    2. PgAdmin  
* [data folder](./data/) : contains data related files
    * archive.zip - raw data downloaded from kaggle
    * [load_data](./data/load_data): sql script to create a procedure called `load_data()` that
        * Drops if table `netflix_shows` exists
        * Creates a new table `netflix_shows`
        * Loads data from the .csv file into the table just created
    * [load](./data/load): bash script that runs `psql` commands to
        1. run the script in load_data file which will create the load_data() procedure
        2. run the command to call the load_data() procedure
* [Makefile](./Makefile): contains commands to: 
    * up: to start the containers
    * load-data: to load the data into the Postgres container by using the `docker exec command`
    * down: to stop the containers
    * clean-slate: to delete the containers, volumes and images
* [queries folder](./queries/): contains the queries run in PgAdmin. This is the data that is stored in the volume mounting of PgAdmin at `/var/lib/docker/volumes/pgadmin_data/_data/storage/admin_admin.com/eda_queries.sql`       