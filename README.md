# Build

    docker build -f Dockerfile -t registry.open-web.nl:5043/hippo:10 .
	docker push registry.open-web.nl:5043/hippo:10

# Usage

    docker pull registry.open-web.nl:5043/hippo:10
    docker run -d -p 8080:8080 --name hippo-node1 -e DB_HOST=my-dbHost -e DB_PORT=3306 -e DB_NAME=dbName -e DB_USER=dbUser -e DB_PASS=dbPass  registry.open-web.nl:5043/hippo:10
    
# To Test

    docker network create --driver bridge test-network-01
    docker run --name test-hippo-mysql --net test-network-01 -e MYSQL_ROOT_PASSWORD=rootPassword -e MYSQL_DATABASE=hippo -e MYSQL_USER=hippo -e MYSQL_PASSWORD=hippoPassword -d mysql:5.5.48
    docker run -d -p 8765:8080 --name test-hippo-01 --net test-network-01 -e DB_HOST=test-hippo-mysql -e DB_PASS=hippoPassword registry.open-web.nl:5043/hippo:mysql-10.0.1

    docker rm -v -f test-hippo-01 test-hippo-mysql
    docker network rm test-network-01