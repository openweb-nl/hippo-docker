#!/bin/bash
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

if [[ "${USE_URANDOM}" == "true" ]]
then
  RANDOM_OPTS="-Djava.security.egd=file:/dev/./urandom"
  else
  RANDOM_OPTS=""
fi

if [[ "${SET_NODE_ID}" == "true" ]]
then
    NODE_ID="$(whoami)-$(hostname -f)"
    JRC_OPTS="-Dorg.apache.jackrabbit.core.cluster.node_id=${NODE_ID}"
else
    JRC_OPTS=""
fi

if [[ ! -z ${MAX_HEAP} ]]
then
    if [[ ! -z ${MIN_HEAP} ]]
    then
        MEM_OPTS="-Xmx${MAX_HEAP}m -Xms${MIN_HEAP}m"
    else
        MEM_OPTS="-Xmx${MAX_HEAP}m"
    fi
else
   MEM_OPTS="-XX:MaxRAMPercentage=${MAX_RAM_PERCENTAGE}.0 -XX:MaxMetaspaceSize=${MAX_METASPACE_SIZE}m -XX:MaxDirectMemorySize=${MAX_DIRECT_MEMORY_SIZE}m"
fi

JVM_OPTS="-server -XshowSettings:vm -XX:-UseContainerSupport -XX:+UnlockExperimentalVMOptions ${MEM_OPTS} -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=${ENCODING} ${RANDOM_OPTS}"
REP_OPTS="-Drepo.bootstrap=${REPO_BOOTSTRAP} -Drepo.config=file:${CATALINA_BASE}/conf/${REP_FILE}"
DMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/logs/"
RMI_OPTS="-Djava.rmi.server.hostname=${RMI_SERVER_HOSTNAME}"
L4J_OPTS="-Dlog4j.configurationFile=file://${CATALINA_BASE}/conf/log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.selector.BasicContextSelector"
VGC_OPTS="-Xlog:gc+ergo*:file=${CATALINA_BASE}/logs/gc.log:time:filecount=5,filesize=2048k"
GEN_OPTS="-DENCODING=${ENCODING} -DMAX_THREADS=${MAX_THREADS} -DACCEPT_COUNT=${ACCEPT_COUNT} -DMAX_CONNECTIONS=${MAX_CONNECTIONS} -DCONNECTION_TIMEOUT=${CONNECTION_TIMEOUT}"

CATALINA_OPTS="${JVM_OPTS} ${VGC_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS} ${GEN_OPTS} ${EXTRA_OPTS}"

export CATALINA_HOME CATALINA_BASE
