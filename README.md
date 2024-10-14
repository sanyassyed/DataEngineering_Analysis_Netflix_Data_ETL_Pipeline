Here is the edited version of your markdown documentation with corrections for typos and readability:

---

# Netflix
* Data Pipeline to Pull and Analyze Netflix Dataset
* Project documentation [here](./Documentation.md)

## Load Pipeline
* Fork this repo and open it in GitCodespace ([Steps here](./Documentation.md#setting-up-git-codespace-instance)) using VSCode or clone the repo on your local system (ensure you have all the required applications installed - [See here](./Documentation.md#application-installation)).
* Download the data:
    * On your host machine, download the data in `archive.zip` format manually from [here](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download).
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

## Important Files
* [Documentation.md](./Documentation.md): Contains the project documentation.
* [Dockerfile](./Dockerfile): This Dockerfile does the following:
    * Creates a container using the PostgreSQL database image.
    * Sets `/data` as the working directory in the container.
    * Copies all the files in the `data` folder on the local system into the `data` folder in the container.
    * Runs commands to update and upgrade `apt-get`, unzip `archive.zip`, and change the permissions for the other files in `data` to 777.
* [docker-compose.yml](./docker-compose.yml): A YAML file that starts two services (as containers) with volume mounting:
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
    * `up`: Starts the containers.
    * `load-data`: Loads the data into the PostgreSQL container using the `docker exec` command.
    * `down`: Stops the containers.
    * `clean-slate`: Deletes the containers, volumes, and images.
* [queries folder](./queries/): Contains the queries run in pgAdmin. This data is stored in the pgAdmin volume mounted at `/var/lib/docker/volumes/pgadmin_data/_data/storage/admin_admin.com/eda_queries.sql`.
  