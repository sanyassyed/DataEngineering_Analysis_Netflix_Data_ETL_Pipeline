# Netflix Data Pipeline
The aim of this project is to do the following:
* Setup a codespace instance
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
* Anaconda
    * Create virtual environment
* Docker
* Docker compose
* Pull images for
    * Postgres
    * Python
    * Jupyter Notebook
* Create volumes for all the above containers
