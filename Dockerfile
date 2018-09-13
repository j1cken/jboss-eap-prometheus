FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

ENV version 0.3.1
ENV config.cli ${JBOSS_HOME/prometheus/jboss-config.cli

RUN mkdir -p ${JBOSS_HOME}/prometheus
ADD config.yaml ${JBOSS_HOME}/prometheus/config.yaml
ADD jboss-config.cli ${config.cli}

RUN curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${version}/jmx_prometheus_javaagent-${version}.jar \
    -o ${JBOSS_HOME}/prometheus/jmx-prometheus.jar \
    && ${JBOSS_HOME}/bin/jboss-cli.sh -f ${config.cli}} \
    && rm ${config.cli}

EXPOSE 9404