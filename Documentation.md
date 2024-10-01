# Netflix Data Pipeline
The aim of this project is to do the following:
* Setup a Git codespace instance [Know more about Git Codespace](https://github.com/features/codespaces)
* Install applications required for the project on the instance
* Build Pipeline to:
    * Pull Netflix dataset
    * Load data in database
    * Perform preliminary EDA in the database using SQL
    * Pull data from database into Python
    * Perform EDA on the dataset using Python

## Steps
### Setting up Git Codespace instance
* Create a new repository on Git named `Netflix`
* Goto [Gitcodespace](https://github.com/codespaces)
* Select the `New codespace` option
* For the Repository select the new repository created `Netflix`
* Select the other required options based on the requirements of the project and create the new codespace instance
* Once the instance starts you can work on the instance from VSCode on your desktop as follows:
    * Goto the project repo on GitHub 
    * Select Code and from the drop down menu goto the Codespaces tab.
    * Click on the three dots in the `On current branch` section and select `Open in VSCode` option
    * Then give permission to GitHub to access VSCode on your system
    * Before that make sure the GitHub Codespaces extension in installed on you VSCode desktop
    * The VSCode should automatically connect to the codespace if not then goto the Remote Explorer Section on the left pane
    * From the drop down menu on top select GitHub Codespaces and then from the options below select the name of the codespace you want to connect to
    * Now you are connected to the Codespace instance
    * Use the bash terminal for the following steps


### Application Installation
1. Anaconda - pre installed in Git Codespace
    * Create virtual environment:
    ```bash
        # Path to install the virtual env in the current project directory with python 3.10 and pip
        conda create --prefix ./.my_env python=3.12 pip 
        #initialize the virtual environment
        conda init
        # restart instance
        source ~/.bashrc
        # now the word (base) should appear
        # Activate the virtual env as follows
        conda activate .my_env 
    ```
1. Docker - pre installed in Git Codespace
1. Docker compose - pre installed in Git Codespace
    * Check Versions of Applications
        ```bash
            # find the versions of the required applications
            conda --version
            python --version
            docker --version
            docker compose version
        ```

1. Jupyter Notebook
    ```bash
        # check if jupyter notebook is installed
        jupyter --version
        # if not install as follows
        pip install jupyter notebook
        # start jupyter notebook
        jupyter notebook
      ```

### Data Extraction

#### Method 1: Manual Download
* Create a folder named data on the codespace instance as follows
```bash
    mkdir data
```
* On your host machine download the data in `archive.zip` format manually from [here](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download).
* Drag and drop the file into the [data folder](./data) of codespace instance on VSCode from the host machine.

#### Method 2: TODO: API
* [Resource](https://github.com/zsvoboda/kaggle2db)
* Kaggle API
    * In order to use Kaggle API we require sign up for an account at [Kaggle](https://www.kaggle.com). 
    * Then go to the `Account` tab of your user profile (https://www.kaggle.com/<username>/account).
    * Select 'Create API Token'. This will trigger the download of kaggle.json, a file containing your API credentials. 
    * The file looks like this:`{"username": "<kaggle-username>", "key": "<kaggle-key>"}`
    * Set the KAGGLE_USERNAME and KAGGLE_KEY environment variables in the bin/env.sh or bin\env.bat script to to the <kaggle-username> and <kaggle-key> values.

### Data Loading
#### Code Files
We need the following files on the Git codespace instance:

##### 1. Git related files
* Git ignore
```bash
    touch .gitignore
```
##### 2. Data & Data Loading Files
1. **[archive.zip](./data/archive.zip)** file: When we run the docker-compose the pgdatabase container will already have the `netflix_titles.csv` data file extracted and available in the `/data` folder.
1. **[load_data](./data/load_data)** file: contains SQL script the creates a procedure which does the following in the `netflix` database:
    1. Deletes the old table and creates a new one
    2. Loads data into it from `netflix_titles.csv` file
1. **[load](./data/load)** file: this file will contain the bash script to perform data loading operations via two commands
    1. The first command runs the SQL script in the `load_data` file which will create a procedure called `load_data()`
    2. The second command will call this stored procedure `load_data()` function which will then delete the old table, create new one, and then load data into it from the CSV file.

##### 3. Postgres DB & PgAdmin Setup Files [Source](https://www.youtube.com/watch?v=ww1Sy2uh_2o)
1. `Dockerfile` - that will build a PgDatabase contianer while baking the above data folder into it
1. `docker-compose.yml` - that will initiate the build of Postgres DB & PgAdmin containers along with `Named Mounting` to store the data

### Running the containers
1. **Start**: the containers so we can create Postgres DB & PgAdmin applications
```bash
    # start the containers in detached mode
    docker compose up -d
```
2. **Verify**: You can view if the data files have loaded into the Postgres DB container called `pgdatabase` by doing the following
```bash
    # start the containers in detached mode
    docker compose up -d
    # check if containers have started
    docker ps -a
    # log into the pg_database container in interactive mode and drop into the bash shell
    docker exec -it pg_database /bin/bash
    # you will log into the working dir which is /data
    ls
    # will display the netflix_titles.csv file
    # stop the containers
    # docker compose down
    # to remove volumes too
    # docker compose down --volumes
    # clean the volumes and containers
    # docker container prune
    # docker volume prune
    # docker volume ls
```
3. **Load data**: While on the Postgres DB container run the bash script in the [load](./data/load) file as follows:
```bash
    ./load
``` 
4. **Use PgAdmin**: Connect to Postgres DB via PgAdmin as follows: [Source Video](https://youtu.be/qECVC6t_2mU?t=197) for following steps
    * Open pgAdmin in the browser via port forwarding available under PORTS tab in VSCode (VSCode should automatically give a prompt)
    * Enter the PgAdmin email and password as in the [docker-compose.yml](./docker-compose.yml) file
    * Then select `Add New Server`
    * In the General Tab give any `Name` eg: `postgresServer`
    * In the Connection Tab -> 
        - Hostname/address: 
            * Option 1: Add the database name `pgdatabase` (the same name as the Postgres DB service mentioned in the docker-compose.yml file) or 
            * Option 2: you can add the ip address of the Postgres DB container by using the following command  `docker inspect pgdatabase_container_id`
        - username & password `root` same as in `docker-compose.yml` file
    * Select `Save` 
    * Now the connection to Postgres DB should show on the left pane of PgAdmin under `Servers -> postgresServer -> Databases -> netflix`
### Preliminary EDA
Now using PgAdmin we can perfrom Preliminary EDA on the netflix_shows table in the netflix database

### Deleting Conatainers & Images & Volumes
```bash
    docker compose down --rmi all --volumes
```

## Run the Load Pipeline
Find [here](./README.md#load-pipeline) the steps to simply run the load pipeline

## PgAdmin container
* Entering via CLI
Use the following command to enter the PgAdmin container shell
```shell
    docker exec -it pg_admin sh
```
* Saved queries:
The queries saved in PgAdmin container can be found here on Gitcodespace
```bash
    sudo ls -lah /var/lib/docker/volumes/pgadmin_data/_data/storage/admin_admin.com
    # copy any file from here onto anywhere in the host machine as follows
    sudo cp -r /var/lib/docker/volumes/pgadmin_data/_data/storage/admin_admin.com/eda_queries.sql ./queries/
```
## Extra Notes:
* Start containers
    ```bash
        # starts the containers in detached mode
        docker compose up -d
    ```
* Test Connection to Postgres DB & PgAdmin:
    1. From host machine Connect to Postgres DB via CLI
    ```bash
        conda activate ./.my_env
        # Installing pgcli
        pip install pgcli
        pip install psycopg_c
        pip install psycopg_binary
        # Use pgcli and connect to Postgres DB
        pgcli -h localhost -p 5432 -u root -d netflix
        # enter the password same as in the docker-compose file
        # View the tables in the Netflix db
        \d
        # view table schema as follows
        \d netflix_shows
    ```

    ## Todo:
    * Pull data directly from kaggle
    * Use a Makefile to run the load code automatically
    * Perform Preliminary EDA using PSQL
    * Pull data into Python
    * Perform EDA

