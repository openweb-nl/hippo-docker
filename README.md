# Build

    docker build -f Dockerfile -t registry.open-web.nl:5043/hippo:10 .
	docker push registry.open-web.nl:5043/hippo:10

# Usage
    docker pull registry.open-web.nl:5043/hippo:10
    docker run -d -p 8080:8080 --name hippo-node1 -e DB_HOST=my-dbHost -e DB_PORT=3306 -e DB_NAME=dbName -e DB_USER=dbUser -e DB_PASS=dbPass  registry.open-web.nl:5043/hippo:10