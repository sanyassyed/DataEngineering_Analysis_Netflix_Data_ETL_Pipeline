# Netflix Data Pipeline
The aim of this project is to do the following:
* Setup a Git codespace instance [Know more about Git Codespace](https://github.com/features/codespaces)
* Build Pipeline to:
    * Pull Netflix dataset
    * Load data in database
    * Pull data from database into Python
    * Perform EDA on the dataset using Python

## Steps
### Setting up codespace instance
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

### Pipeline
#### Install required applications
* Anaconda - pre installed in Git Codespace
    * Create virtual environment
* Docker - pre installed in Git Codespace
* Docker compose - pre installed in Git Codespace
* Pull docker images for
    * Postgres
    * Jupyter Notebook
    ```bash
        # find the versions of the required applications
        conda --version
        python --version
        docker --version
        docker compose version
        mkdir postgres eda
    ```
* Create volumes for all the above containers on the host machine where the data will be stored

