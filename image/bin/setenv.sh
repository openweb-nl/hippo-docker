CATALINA_HOME="/usr/local/tomcat"
CATALINA_BASE="/usr/local/tomcat"
CATALINA_PID="${CATALINA_BASE}/work/catalina.pid"
JAVA_ENDORSED_DIRS=${CATALINA_HOME}/endorsed



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


if [[ "${SET_NODE_ID}" == "true" ]]
then
    NODE_ID="$(whoami)-$(hostname -f)"
    JRC_OPTS="-Dorg.apache.jackrabbit.core.cluster.node_id=${NODE_ID}"
else
    JRC_OPTS=""
fi

JVM_OPTS="-server -Xmx${MAX_HEAP}m -Xms${MIN_HEAP}m -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=${ENCODING}"
REP_OPTS="-Drepo.bootstrap=${REPO_BOOTSTRAP} -Drepo.config=file:${CATALINA_BASE}/conf/${REP_FILE}"
DMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/logs/"
RMI_OPTS="-Djava.rmi.server.hostname=${RMI_SERVER_HOSTNAME}"
L4J_OPTS="-Dlog4j.configurationFile=file://${CATALINA_BASE}/conf/log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.selector.BasicContextSelector"
VGC_OPTS="-verbosegc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:${CATALINA_BASE}/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=2048k"
GEN_OPTS="-DENCODING=${ENCODING}"

CATALINA_OPTS="${JVM_OPTS} ${VGC_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS} ${GEN_OPTS} ${EXTRA_OPTS}"

export CATALINA_HOME CATALINA_BASE