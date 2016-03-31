#docker build -f Dockerfile -t registry.open-web.nl:5043/hippo:mysql-10.0.1 .
FROM registry.open-web.nl:5043/oracle-tomcat:8-jre8
MAINTAINER Ebrahim Aharpour <ebrahim@openweb.nl>

# General configuration
ENV ENCODING=UTF-8
ENV CATALINA_HOME /usr/local/tomcat

# JVM configuration
ENV MAX_HEAP=512
ENV MIN_HEAP=256
ENV EXTERA_OPTS=

# RMI configuration
ENV RMI_SERVER_HOSTNAME=127.0.0.1

# Mail Session configuration
ENV MAIL_SESSION_RESOURCE_NAME=mail/Session
ENV MAIL_USERNAME=
ENV MAIL_PASSWORD=
ENV MAIL_HOST=local
ENV MAIL_DEBUG
ENV MAIL_PROTOCOL=smtp
ENV MAIL_AUTH=true
ENV MAIL_PORT=25
ENV MAIL_TLS_ENABLE=true

# Database configuration
ENV DB_RESOURCE_NAME=jdbc/repositoryDS
ENV DB_HOST=
ENV DB_PORT=3306
ENV DB_NAME=hippo
ENV DB_USER=hippo
ENV DB_PASS=

# JDBC configuration
ENV MYSQL_CONNECTOR_VERSION=5.1.38

WORKDIR $CATALINA_HOME

RUN rm -rf $CATALINA_HOME/webapps/*
RUN mkdir -p $CATALINA_HOME/endorsed
RUN curl -s -o $CATALINA_HOME/endorsed/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar

COPY bin/setenv.sh $CATALINA_HOME/bin/setenv.sh
COPY conf/repository.xml $CATALINA_HOME/conf/repository.xml
COPY conf/context.xml $CATALINA_HOME/conf/context.xml
COPY conf/server.xml $CATALINA_HOME/conf/server.xml
COPY conf/catalina.properties $CATALINA_HOME/conf/catalina.properties
COPY conf/catalina.policy $CATALINA_HOME/conf/catalina.policy
COPY conf/log4j.xml $CATALINA_HOME/conf/log4j.xml

RUN chmod +x $CATALINA_HOME/bin/setenv.sh

EXPOSE 1099

VOLUME ["/usr/local/repository/", "/usr/local/tomcat/logs"]

CMD ["catalina.sh", "run"]