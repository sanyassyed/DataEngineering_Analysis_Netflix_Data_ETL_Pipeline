# This forcefully removes the Docker containers named pg_database and pg_admin. If the containers are running, they will be stopped first.
clean-slate:
	docker rm -f pg_database pg_admin
	docker volume rm  pg_data pgadmin_data

#This starts all the services defined in the docker-compose.yml file. The --build flag ensures that the images are rebuilt before starting, and -d runs the services in the background (detached mode).
up: 
	docker compose up --build -d

# This stops the running containers and removes the containers, networks, and other resources defined in the docker-compose.yml
down:
	docker compose down

# This executes the ./load script inside the running database container. The script likely loads the necessary data into the database.
load-data:
	docker exec pg_database ./load 