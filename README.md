### About this image

This docker image is not meant for direct usage. It is meant to be used as an extension point. For instruction on how to dockerify your Hippo project please the instruction below.

If you are looking for a runnable docker image to test drive Hippo CMS you can use one of the following docker images

* [Hippo out of the box docker image] - Hippo Community edition as it comes out of the box.
* [Gogreen docker image] - Community edition of Hippo gogreen demo website.


### How to dockerify a Hippo project

**Step 1:** In the root pom file add finalName element with ${project.artifactId} As value to the build section of dist profile
```XML
..
<profile>
 <id>dist</id>
 ..
 <build>
   <finalName>${project.artifactId}</finalName>
   ..
 </build>

</profile>
```

**Step 2:** Add the following profile to your root pom.xml file.
```XML
<profile>
 <id>docker</id>
 <build>
   <plugins>
	 <plugin>
	   <groupId>com.spotify</groupId>
	   <artifactId>docker-maven-plugin</artifactId>
	   <version>0.4.3</version>
	   <configuration>
		 <imageName>your-docker-registry/${project.artifactId}</imageName>
		 <dockerDirectory>src/main/docker</dockerDirectory>
		 <resources>
		   <resource>
			 <directory>${project.build.directory}</directory>
			 <include>${project.artifactId}-distribution.tar.gz</include>
		   </resource>
		 </resources>
		 <imageTags>
		   <imageTag>${project.version}</imageTag>
		   <!--<imageTag>latest</imageTag>-->
		 </imageTags>
		 <forceTags>true</forceTags>
		 <serverId>your-docker-registry-serverId</serverId>
		 <registryUrl>your-docker-registry-url</registryUrl>
		 <pullOnBuild>true</pullOnBuild>
	   </configuration>
	   <executions>
		 <execution>
		   <id>docker-build</id>
		   <phase>validate</phase>
		   <goals>
			 <goal>build</goal>
		   </goals>
		 </execution>
	   </executions>
	 </plugin>
   </plugins>
 </build>

 <modules></modules>

</profile>
```

**Step 3:** Add a docker file at src/main/docker/Dockerfile With the following content

	FROM openweb/hippo:mysql-10

	ADD artifactId-distribution.tar.gz /usr/local/tomcat


**Step 4:** Make sure that your distribution package does not contain a context.xml or repository.xml file.

### To Build a docker image

	mvn clean install
	mvn -P dist
	mvn -P docker


### Run your docker image

#### Without docker-compose

	docker network create --driver bridge hippo-demo-network

	docker run --name hippo-demo-mysql \
		--net hippo-demo-network \
		-e MYSQL_ROOT_PASSWORD=rootPassword \
		-e MYSQL_DATABASE=hippo \
		-e MYSQL_USER=hippo \
		-e MYSQL_PASSWORD=hippoPassword \
		-d mysql:5.5

	docker run -d -p 8585:8080 --name hippo-demo-node1 \
		--net hippo-demo-network \
		-e DB_HOST=hippo-demo-mysql \
		-e DB_PORT=3306 -e DB_NAME=hippo \
		-e DB_USER=hippo \
		-e DB_PASS=hippoPassword \
		*your-docker-registry/your-artifact-id:your-project-version*


#### With docker-compose

Create a file called docker-compose.yml with the following content

```yml
version: '2'

services:
  hippo:
    image: *your-docker-registry/your-artifact-id:your-project-version*
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
      - "8585:8080"
    restart: always
  mysql:
    image: mysql:5.5
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
    restart: always
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
```

Then start the containers with running the following command in the folder that you created the file

```bash
docker-compose up -d
```

[Hippo out of the box docker image]: <https://hub.docker.com/r/openweb/hippo-cms-ootb/>
[Gogreen docker image]: <https://hub.docker.com/r/openweb/gogreen/>