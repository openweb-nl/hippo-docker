CATALINA_HOME="/usr/local/tomcat"
CATALINA_BASE="/usr/local/tomcat"
CATALINA_PID="${CATALINA_BASE}/work/catalina.pid"
JAVA_ENDORSED_DIRS=${CATALINA_HOME}/endorsed

CLUSTER_ID="$(whoami)-$(hostname -f)"

if [[ "${CONSISTENCY_CHECK}" == "check" ]]
then
        REP_FILE="repository-consistency.xml"
else
        if [[ "${CONSISTENCY_CHECK}" == "check-force" ]]
        then
                REP_FILE="repository-force.xml"
        else
                REP_FILE="repository.xml"
        fi
fi

JVM_OPTS="-server -Xmx${MAX_HEAP}m -Xms${MIN_HEAP}m -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=${ENCODING}"
REP_OPTS="-Drepo.bootstrap=true -Drepo.config=file:${CATALINA_BASE}/conf/${REP_FILE}"
DMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/logs/"
RMI_OPTS="-Djava.rmi.server.hostname=${RMI_SERVER_HOSTNAME}"
L4J_OPTS="-Dlog4j.configuration=file:${CATALINA_BASE}/conf/log4j.xml"
JRC_OPTS="-Dorg.apache.jackrabbit.core.cluster.node_id=${CLUSTER_ID}"
DB_OPTS="-DDB_RESOURCE_NAME=${DB_RESOURCE_NAME} -DDB_HOST=${DB_HOST} -DDB_PORT=${DB_PORT} -DDB_NAME=${DB_NAME} -DDB_USER=${DB_USER} -DDB_PASS=${DB_PASS}"
MAIL_OPTS="-DMAIL_SESSION_RESOURCE_NAME=${MAIL_SESSION_RESOURCE_NAME} -DMAIL_USERNAME=${MAIL_USERNAME} -DMAIL_PASSWORD=${MAIL_PASSWORD} -DMAIL_HOST=${MAIL_HOST} -DMAIL_DEBUG=${MAIL_DEBUG} -DMAIL_PROTOCOL=${MAIL_PROTOCOL} -DMAIL_AUTH=${MAIL_AUTH} -DMAIL_PORT=${MAIL_PORT} -DMAIL_TLS_ENABLE=${MAIL_TLS_ENABLE}"
GEN_OPTS="-DENCODING=${ENCODING}"

CATALINA_OPTS="${JVM_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS} ${DB_OPTS} ${MAIL_OPTS} ${GEN_OPTS} ${EXTERA_OPTS}"

export CATALINA_HOME CATALINA_BASE