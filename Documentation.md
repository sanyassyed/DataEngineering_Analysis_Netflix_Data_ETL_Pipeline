# Netflix Data Pipeline
The aim of this project is to do the following:
* Setup a Git codespace instance [Know more about Git Codespace](https://github.com/features/codespaces)
* Build Pipeline to:
    * Pull Netflix dataset
    * Load data in database
    * Pull data from database into Python
    * Perform EDA on the dataset using Python

## Steps
### Setting up Codespace instance
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
    * The VSCode should automatically connect to the codespace if not the goto the Remote Explorer Section
    * From the drop down menu on top select GitHub Codespaces and then from the options below select the name of the codespace you want to connect to
### Git related files
    * Git ignore
    ```bash
        touch .gitignore
    ```
    * Commit Changes
### Project Application Installation
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
2. Docker - pre installed in Git Codespace
3. Docker compose - pre installed in Git Codespace
    * Check Versions of Applications
        ```bash
            # find the versions of the required applications
            conda --version
            python --version
            docker --version
            docker compose version
            # volume folder for postgres container
            mkdir postgres_volume 
        ```
4. Postgres & PgAdmin Setup
    * Create docker-composer.yml file to use Postgres & PgAdmin containers
    * Create volume folder (for Postgres & PgAdmin) on the host machine where the data will be stored
    ```bash
        mkdir volume
        mkdir volume/pgadmin
        mkdir volume/postgres
    ```
    * Connect and use:
        1. Postgres DB via CLI
        ```bash
            conda activate ./.my_env
            # Installing pgcli
            pip install pgcli
            pip install psycopg_c
            pip install psycopg_binary
            # Use pgcli and connect to Postgres
            pgcli -h localhost -p 5432 -u root -d netflix
            # enter the password same as in the docker-compose file
            # View the tables in the Netflix db
            \d
        ```
        2. Postgres DB via PgAdmin
            * Open pgAdmin in the browser via port forwarding (VsCode should automatically give a prompt)
            * [Source Video](https://youtu.be/qECVC6t_2mU?t=197) for following steps
            * Get the Postgres ip address via `docker inspect pgdatabase_container_id`
            * In pgAdmin select `Add New Server`
            * Give any name eg: `postgresServer`
            * Connection Tab -> Hostname add the ip address found earlier
            * username & password `root` same as in docker-compose.yml file
            * Select ok and now the connection to postgres should show on the left pane

5. Jupyter Notebook
    ```bash
        # check if jupyter notebook is installed
        jupyter --version
        # if not install as follows
        pip install jupyter notebook
        # start jupyter notebook
        jupyter notebook
      ```

### Data Extraction
* [Resource](https://github.com/zsvoboda/kaggle2db)
* Kaggle API
    * In order to use Kaggle API we require sign up for an account at [Kaggle](https://www.kaggle.com). 
    * Then go to the `Account` tab of your user profile (https://www.kaggle.com/<username>/account).
    * Select 'Create API Token'. This will trigger the download of kaggle.json, a file containing your API credentials. 
    * The file looks like this:`{"username": "<kaggle-username>", "key": "<kaggle-key>"}`
    * Set the KAGGLE_USERNAME and KAGGLE_KEY environment variables in the bin/env.sh or bin\env.bat script to to the <kaggle-username> and <kaggle-key> values.

