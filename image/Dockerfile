#docker build --no-cache -f Dockerfile -t openweb/hippo:mysql-15 .
FROM tomcat:10.1.30-jdk17-temurin-jammy
LABEL org.opencontainers.image.authors="Open Web IT B.V. <info@openweb.nl>"

ENV ENCODING=UTF-8 \
    CATALINA_HOME=/usr/local/tomcat \
\
    MAX_HEAP="" \
    MIN_HEAP="" \
    MAX_RAM_PERCENTAGE=25 \
    MAX_METASPACE_SIZE=200 \
    MAX_DIRECT_MEMORY_SIZE=100 \
    USE_URANDOM=false \
    EXTRA_OPTS="" \
\
    MAX_THREADS=16 \
    ACCEPT_COUNT=5 \
    MAX_CONNECTIONS=5000 \
    CONNECTION_TIMEOUT=20000 \
\
    ENABLE_RMI=false \
    RMI_SERVER_HOSTNAME=127.0.0.1 \
\
    MAIL_SESSION_RESOURCE_NAME=mail/Session \
    MAIL_USERNAME="" \
    MAIL_PASSWORD="" \
    MAIL_HOST=localhost \
    MAIL_LOCAL_HOST=localhost \
    MAIL_DEBUG=false \
    MAIL_PROTOCOL=smtp \
    MAIL_AUTH=true \
    MAIL_PORT=25 \
    MAIL_FROM="" \
    MAIL_TLS_ENABLE=true \
\
    DB_RESOURCE_NAME=jdbc/repositoryDS \
    DB_HOST="" \
    DB_PORT=3306 \
    DB_NAME=hippo \
    DB_USER=hippo \
    DB_PASS="" \
    DB_USE_SSL="false" \
    DB_ALLOW_PUBLIC_KEY_RETRIEVAL="true" \
\
    MYSQL_CONNECTOR_VERSION=8.4.0 \
\
    REPO_BOOTSTRAP=true \
    SET_NODE_ID=true \
    CONSISTENCY_CHECK=none

WORKDIR $CATALINA_HOME

COPY ["bin/setenv.sh", \
        "bin/wait-for-it.sh", \
        "bin/entrypoint.sh", \
    "$CATALINA_HOME/bin/"]

COPY ["conf/repository.xml", \
        "conf/repository-consistency.xml", \
        "conf/repository-force.xml", \
        "conf/context.xml.template", \
        "conf/server.xml", \
        "conf/catalina.properties", \
        "conf/catalina.policy", \
        "conf/log4j2.xml", \
    "$CATALINA_HOME/conf/"]

ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/$MYSQL_CONNECTOR_VERSION/mysql-connector-j-$MYSQL_CONNECTOR_VERSION.jar $CATALINA_HOME/lib/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar

RUN rm -rf "$CATALINA_HOME/webapps/*" &&\
  chmod +x "$CATALINA_HOME/bin/setenv.sh" &&\
	chmod +x bin/wait-for-it.sh &&\
	chmod +x bin/entrypoint.sh

EXPOSE 8080
EXPOSE 1099

VOLUME ["/usr/local/repository/", "/usr/local/tomcat/logs"]
ENTRYPOINT ["bin/entrypoint.sh"]
CMD ["/bin/bash", "catalina.sh", "run"]
