FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

ENV version 0.3.1 \
    cli ${JBOSS_HOME}/bin/jboss-config.cli \
    launch ${JBOSS_HOME}/bin/openshift-launch.sh

ADD openshift-launch.sh ${launch}
ADD jboss-config.cli ${cli}

RUN chmod a+x ${launch} \
    mkdir -p ${JBOSS_HOME}/prometheus \
    && curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${version}/jmx_prometheus_javaagent-${version}.jar \
    -o ${JBOSS_HOME}/prometheus/jmx-prometheus.jar
ADD config.yaml ${JBOSS_HOME}/prometheus/config.yaml

EXPOSE 9404