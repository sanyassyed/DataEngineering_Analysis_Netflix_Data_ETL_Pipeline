# Netflix
* Data Pipeline to Pull and Analyze Netflix Dataset
* Project documentation [here](./Documentation.md)
## Load Pipeline
* Fork this repo and open it in GitCodespace [Steps](./Documentation.md#setting-up-git-codespace-instance) using VSCode or clone the repo
*  Download the data:
    * On your host machine download the data in `archive.zip` format manually from [here](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download).
    * Drag and drop the file into the [data folder](./data) of codespace instance on VSCode from the host machine.
* Run the following commands in the terminal
```bash
    make up #starts the cotainers
    make load-data # populates the pgadmin tables with the flight data
```
* Goto the `PORTS` tab in VSCode and click on the URL
* Log into PgAdmin to view the netflix database Steps [here-Point 4](./Documentation.md#running-the-containers)
* To Shutdown the containers run the following commands
```bash
    make down
    make clean-slate
```