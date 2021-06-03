### About this image

This docker image is not meant for direct usage. It is meant to be used as an extension point. For instruction on how to dockerify your Hippo project please the instruction below.

If you are looking for a runnable docker image to test drive Hippo CMS you can use one of the following docker images

* [Hippo out of the box docker image] - Hippo Community edition as it comes out of the box.
* [Gogreen docker image] - Community edition of Hippo gogreen demo website.

## Important notice:
The latest version of this image is no longer sets "-Xmx" JVM arguments by default. Instead, it supports "-XX:MaxRAMPercentage".

To still set "-Xmx" and "-Xms" you need to set environmental variables MAX_HEAP and MIN_HEAP explicitly on the container.

To change the value of -XX:MaxRAMPercentage you can use environmental variable MAX_RAM_PERCENTAGE. The value of this
variable is expected to be an **Integer** like 50 (Not 50.0)

If you are using MaxRAMPercentage make sure that you leave at least 512Mb for the native memory, 
e.g. if you set a maximum memory limit of 1024Mb then set MAX_RAM_PERCENTAGE to 50 percent or less.

### How to dockerify a Hippo project

**Step 1:** Add the following profile to your root pom.xml file.
```XML
<profile>
  <id>docker</id>
  <build>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>3.0.0</version>
        <executions>
          <execution>
            <id>docker-build</id>
            <phase>package</phase>
            <goals>
              <goal>exec</goal>
            </goals>
            <configuration>
              <executable>docker</executable>
              <workingDirectory>${project.basedir}</workingDirectory>
              <arguments>
                <argument>build</argument>
                <argument>--pull</argument>
                <argument>-t</argument>
                <argument>your-docker-registry/${project.artifactId}:${project.version}</argument>
                <argument>.</argument>
              </arguments>
            </configuration>
          </execution>
          <!-- Push the image to a docker repo. -->
          <execution>
            <id>docker-push</id>
            <phase>install</phase>
            <goals>
              <goal>exec</goal>
            </goals>
            <configuration>
              <executable>docker</executable>
              <workingDirectory>${project.basedir}</workingDirectory>
              <arguments>
                <argument>push</argument>
                <argument>your-docker-registry/${project.artifactId}:${project.version}</argument>
              </arguments>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
  <modules/>
</profile>
```

**Step 2:** Add a docker file called Dockerfile in the root of the project with the following content

```dockerfile
FROM openweb/hippo:postgresql-13

ADD target/<artifactId>-*-distribution.tar.gz /usr/local/tomcat
```

**Step 3:** Add a docker ignore file called ".dockerignore" to the root of the project with the following content
```ignore
.idea
cms
cms-dependencies
conf
db-bootstrap
essentials
repository-data
site
src
target
.gitignore
.dockerignore
*.iml
pom.xml
!target/<artifactId>-*-distribution.tar.gz
```

**Step 4:** Make sure that your distribution package does not contain a context.xml or repository.xml file.


**Step 5:** If you want to push the image to a docker registry make sure that you are already logged into that registry 

### To build a docker and push it to your registry

```bash
mvn clean install
mvn -P dist
mvn -P docker install
```
### To build a docker (without pushing it for a registry)

```bash
mvn clean install
mvn -P dist
mvn -P docker package
```

### Run your docker image

Create a file called docker-compose.yml with the following content

```yaml
version: '2'

services:
  hippo:
    image: your-docker-registry/your-artifact-id:your-project-version
    volumes:
      - hippo_repository:/usr/local/repository/
      - hippo_logs:/usr/local/tomcat/logs
    environment:
      DB_HOST: "postgres"
      DB_PORT: "5432"
      DB_NAME: "hippo"
      DB_USER: "hippo"
      DB_PASS: "hippoPassword"
      MAIL_AUTH: "false"
      MAIL_TLS_ENABLE: "false"
      MAIL_HOST: "mailcatcher"
      TZ: "Europe/Amsterdam"
      MAX_HEAP: "512"
      MIN_HEAP: "256"
    depends_on:
      - postgres
      - mailcatcher
    ports:
      - "8765:8080"
    restart: always
  postgres:
    image: postgres:12
    environment:
      POSTGRES_USER: "hippo"
      POSTGRES_DB: "hippo"
      POSTGRES_PASSWORD: "hippoPassword"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: always
  mailcatcher:
      image: tophfr/mailcatcher:latest
      environment:
        TZ: "Europe/Amsterdam"
      ports:
        - "8586:80"
      restart: always
volumes:
  postgres_data:
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
