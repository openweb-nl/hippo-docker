# registry.open-web.nl:5043/hippo:10
FROM registry.open-web.nl:5043/openweb-tomcat:tomcat8-jre8

ENV CATALINA_HOME /usr/local/tomcat
WORKDIR $CATALINA_HOME

RUN mkdir -p $CATALINA_HOME/endorsed
# RUN curl -s -o $CATALINA_HOME/endorsed/geronimo-jta_1.1_spec-1.1.jar -L https://repo1.maven.org/maven2/org/apache/geronimo/specs/geronimo-jta_1.1_spec/1.1/geronimo-jta_1.1_spec-1.1.jar
# RUN curl -s -o $CATALINA_HOME/endorsed/mail-1.4.7.jar -L https://repo1.maven.org/maven2/javax/mail/mail/1.4.7/mail-1.4.7.jar
# RUN curl -s -o $CATALINA_HOME/endorsed/jcr-2.0.jar -L https://repo1.maven.org/maven2/javax/jcr/jcr/2.0/jcr-2.0.jar
RUN curl -s -o $CATALINA_HOME/endorsed/mysql-connector-java-5.1.38.jar -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.38/mysql-connector-java-5.1.38.jar

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