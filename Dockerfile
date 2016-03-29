#docker build -f Dockerfile -t registry.open-web.nl:5043/hippo:mysql-10.0.1 .
FROM registry.open-web.nl:5043/openweb-tomcat:tomcat8-jre8
MAINTAINER Ebrahim Aharpour <ebrahim@openweb.nl>

ENV CATALINA_HOME /usr/local/tomcat

ENV MAX_HEAP=512
ENV MIN_HEAP=256
ENV DB_PORT=3306
ENV DB_NAME=hippo
ENV DB_USER=hippo
ENV MYSQL_CONNECTOR_VERSION=5.1.38

WORKDIR $CATALINA_HOME

RUN mkdir -p $CATALINA_HOME/endorsed
RUN curl -s -o $CATALINA_HOME/endorsed/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar

COPY bin/setenv.sh $CATALINA_HOME/bin/setenv.sh
COPY conf/repository.xml $CATALINA_HOME/conf/repository.xml
COPY conf/context.xml $CATALINA_HOME/conf/context.xml
COPY conf/catalina.properties $CATALINA_HOME/conf/catalina.properties
COPY conf/catalina.policy $CATALINA_HOME/conf/catalina.policy
COPY conf/log4j.xml $CATALINA_HOME/conf/log4j.xml

RUN chmod +x $CATALINA_HOME/bin/setenv.sh

EXPOSE 1099

VOLUME ["/usr/local/repository/", "/usr/local/tomcat/logs"]

CMD ["catalina.sh", "run"]