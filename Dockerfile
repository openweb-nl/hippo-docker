FROM tomcat:7-jre7

#ADD app.tar.gz /app/app.tar.gz
Copy app.tar.gz /app/app.tar.gz

RUN tar -xvf /app/app.tar.gz
#CMD ["/bin/sh"]