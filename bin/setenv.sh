CATALINA_HOME="/usr/local/tomcat"
CATALINA_BASE="/usr/local/tomcat"
CATALINA_PID="${CATALINA_BASE}/work/catalina.pid"
JAVA_ENDORSED_DIRS=${CATALINA_HOME}/endorsed

CLUSTER_ID="$(whoami)-$(hostname -f)"

MAX_HEAP=512
MIN_HEAP=256

REP_OPTS="-Drepo.bootstrap=true -Drepo.config=file:${CATALINA_BASE}/conf/repository.xml"
JVM_OPTS="-server -Xmx${MAX_HEAP}m -Xms${MIN_HEAP}m -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true"
DMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/logs/"
RMI_OPTS="-Djava.rmi.server.hostname=127.0.0.1"
JRC_OPTS="-Dorg.apache.jackrabbit.core.cluster.node_id=${CLUSTER_ID}"
L4J_OPTS="-Dlog4j.configuration=file:${CATALINA_BASE}/conf/log4j.xml"

CATALINA_OPTS="${JVM_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS}"

export CATALINA_HOME CATALINA_BASE