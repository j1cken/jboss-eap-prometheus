FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

ENV version 0.3.1
ENV config.cli /tmp/jboss-config.cli

RUN mkdir -p ${JBOSS_HOME}/prometheus \
    && curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${version}/jmx_prometheus_javaagent-${version}.jar \
    -o ${JBOSS_HOME}/prometheus/jmx-prometheus.jar \
    && content=$(cat <<EOF
embed-server --server-config standalone-openshift.xml
/subsystem=undertow :write-attribute(name=statistics-enabled,value=true)
stop-embedded-server
EOF
    ) \
    && echo -e ${content} >${config.cli} \
    && ${JBOSS_HOME}/bin/jboss-cli.sh -f ${config.cli}} \
    && rm ${config.cli}

ADD config.yaml ${JBOSS_HOME}/prometheus/config.yaml

EXPOSE 9404