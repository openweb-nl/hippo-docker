# Usage
## Without Docker compose

    docker pull openweb/hippo:mysql-10
    
    docker run -d -p 8080:8080 \
        --name hippo-node1 \
        --restart unless-stopped \
        -e DB_HOST=my-dbHost \
        -e DB_PORT=3306 \
        -e DB_NAME=dbName \
        -e DB_USER=dbUser \
        -e DB_PASS=dbPass  \
            openweb/hippo:mysql-10.1
            
## With Docker compose
create a file call "docker-compose.yaml" with the follwoing content

    version: '2'

    services:
      hippo:
        image: openweb/hippo:mysql-10
        networks:
          - app_network
        volumes:
          - hippo_repository:/usr/local/repository/
          - hippo_logs:/usr/local/tomcat/logs
        environment:
          DB_HOST: "database"
          DB_PORT: "3306"
          DB_NAME: "hippo"
          DB_USER: "hippo"
          DB_PASS: "hippoPassword"
        depends_on:
          - mysql
        ports:
          - "8765:8080"
      mysql:
        image: mysql:5.7
        volumes:
          - mysql_data:/var/lib/mysql
        environment:
          MYSQL_ROOT_PASSWORD: "rootPassword"
          MYSQL_DATABASE: "hippo"
          MYSQL_USER: "hippo"
          MYSQL_PASSWORD: "hippoPassword"
        networks:
          app_network:
            aliases:
              - database 
    volumes:
      mysql_data:
        driver: local
      hippo_repository:
        driver: local
      hippo_logs:
        driver: local 
    networks:
      app_network:
        driver: bridge

Then run the following commands

    docker pull openweb/hippo:mysql-10
    docker-compose up -d

# Build

    docker build -f Dockerfile -t openweb/hippo:mysql-10 .
	docker push openweb/hippo:mysql-10
    
# To Test

    docker network create --driver bridge test-network-01
    docker run --name test-hippo-mysql --net test-network-01 -e MYSQL_ROOT_PASSWORD=rootPassword -e MYSQL_DATABASE=hippo -e MYSQL_USER=hippo -e MYSQL_PASSWORD=hippoPassword -d mysql:5.5.48
    docker run -d -p 8765:8080 --name test-hippo-01 --net test-network-01 -e DB_HOST=test-hippo-mysql -e DB_PASS=hippoPassword openweb/hippo:mysql-10

    docker rm -v -f test-hippo-01 test-hippo-mysql
    docker network rm test-network-01