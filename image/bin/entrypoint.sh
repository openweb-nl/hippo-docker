#!/bin/bash
echo "Generating context.xml"

sed 's/\${DB_HOST}/'$DB_HOST'/g;s/\${DB_PORT}/'$DB_PORT'/g;s/\${DB_NAME}/'$DB_NAME'/g;s/\${DB_USER}/'$DB_USER'/g;s/\${DB_PASS}/'$DB_PASS'/g;s/\${DB_RESOURCE_NAME}/'${DB_RESOURCE_NAME//\//\\/}'/g;s/\${MAIL_SESSION_RESOURCE_NAME}/'${MAIL_SESSION_RESOURCE_NAME//\//\\/}'/g;s/\${MAIL_HOST}/'$MAIL_HOST'/g;s/\${MAIL_DEBUG}/'$MAIL_DEBUG'/g;s/\${MAIL_PROTOCOL}/'$MAIL_PROTOCOL'/g;s/\${MAIL_AUTH}/'$MAIL_AUTH'/g;s/\${MAIL_PORT}/'$MAIL_PORT'/g;s/\${MAIL_TLS_ENABLE}/'$MAIL_TLS_ENABLE'/g;s/\${MAIL_USERNAME}/'$MAIL_USERNAME'/g;s/\${MAIL_PASSWORD}/'$MAIL_PASSWORD'/g;s/\${MAIL_USERNAME}/'$MAIL_USERNAME'/g;s/\${MAIL_PASSWORD}/'$MAIL_PASSWORD'/g;s/\${MAIL_FROM}/'$MAIL_FROM'/g;s/\${MAIL_LOCAL_HOST}/'$MAIL_LOCAL_HOST'/g' ${CATALINA_HOME}/conf/context.xml.template > ${CATALINA_HOME}/conf/context.xml

echo "Waiting for database connection..."
bin/wait-for-it.sh -t 0 ${DB_HOST}:${DB_PORT}
echo "Successfully found the database connection..."
exec "$@"