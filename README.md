### About this image

This docker image is not meant for direct usage. It is meant to be used as an extension point. For instruction on how to dockerify your Hippo project please the instruction below.

If you are looking for a runnable docker image to test drive Hippo CMS you can use one of the following docker images

* [Hippo out of the box docker image] - Hippo Community edition as it comes out of the box.
* [Gogreen docker image] - Community edition of Hippo gogreen demo website.


### How to dockerify a Hippo project

**Step 1:** Add the following profile to your root pom.xml file.
```XML
<profile>
  <id>docker</id>
  <build>
	<plugins>
	  <plugin>
		<groupId>com.spotify</groupId>
		<artifactId>dockerfile-maven-plugin</artifactId>
		<version>1.3.6</version>
		<inherited>false</inherited>
		<configuration>
		  <repository>docker-repo.example.com:8080/${project.artifactId}</repository>
		  <tag>${project.version}</tag>
		  <pullNewerImage>true</pullNewerImage>
	          <useMavenSettingsForAuth>true</useMavenSettingsForAuth>
		</configuration>
		<executions>
		  <execution>
			<id>docker-build</id>
			<phase>compile</phase>
			<goals>
			  <goal>build</goal>
			</goals>
		  </execution>
		  <execution>
			<id>docker-push</id>
			<phase>package</phase>
			<goals>
			  <goal>push</goal>
			</goals>
		  </execution>
		</executions>
	  </plugin>
	</plugins>
  </build>
  <modules/>
</profile>
```
## Authenticating with maven settings.xml

Since version 1.3.6, you can authenticate using your maven settings.xml instead
of docker configuration.  Just add configuration similar to:

```xml
<configuration>
  <repository>docker-repo.example.com:8080/image</repository>
  <tag>latest</tag>
  <useMavenSettingsForAuth>true</useMavenSettingsForAuth>
</configuration>
```

You can also use `-Ddockerfile.useMavenSettingsForAuth=true` on the command line.

Then, in your maven settings file, add configuration for the server:

```xml
<servers>
  <server>
    <id>docker-repo.example.com:8080</id>
    <username>me</username>
    <password>mypassword</password>
  </server>
</servers>
```

**Step 2:** Add a docker file called Dockerfile in the root of the project with the following content

	FROM openweb/hippo:mysql-10

	ADD target/artifactId-*-distribution.tar.gz /usr/local/tomcat


**Step 3:** Make sure that your distribution package does not contain a context.xml or repository.xml file.

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
		-d mysql:5.7

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
    image: your-docker-registry/your-artifact-id:your-project-version
    volumes:
      - hippo_repository:/usr/local/repository/
      - hippo_logs:/usr/local/tomcat/logs
    environment:
      DB_HOST: "mysql"
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
    image: mysql:5.7
    volumes:
      - mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: "rootPassword"
      MYSQL_DATABASE: "hippo"
      MYSQL_USER: "hippo"
      MYSQL_PASSWORD: "hippoPassword"
    restart: always
volumes:
  mysql_data:
    driver: local
  hippo_repository:
    driver: local
  hippo_logs:
    driver: local
```

Then start the containers with running the following command in the folder that you created the file

```bash
docker-compose up -d
```

[Hippo out of the box docker image]: <https://hub.docker.com/r/openweb/hippo-cms-ootb/>
[Gogreen docker image]: <https://hub.docker.com/r/openweb/gogreen/>
