database-docker-up:
	docker volume create mysql-db-data
	docker run -d -p 33060:3306 --name mysql-db -e MYSQL_ROOT_PASSWORD=mysql --mount src=mysql-db-data,dst=/var/lib/mysql mysql:5
	docker cp "$(shell pwd)/database_create.sql" mysql-db:/docker-entrypoint-initdb.d/database_create.sql
#   -v "$(shell pwd)/database_create.sql":/docker-entrypoint-initdb.d/database_create.sql	
	docker exec -it mysql-db ls -ltr /docker-entrypoint-initdb.d
	docker exec -it mysql-db chmod 755 /docker-entrypoint-initdb.d/database_create.sql
	docker exec -it mysql-db chown root:root /docker-entrypoint-initdb.d/database_create.sql
	docker exec -it mysql-db ls -ltr /docker-entrypoint-initdb.d
	docker restart mysql-db

database-up:
	make database-docker-up

database-reset:
	make database-down
	make database-up

database-down:
	docker rm -f mysql-db
	docker volume rm mysql-db-data