FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

ENV VERSION=0.3.1 \
    CLI=${JBOSS_HOME}/bin/jboss-config.cli \
    LAUNCH=${JBOSS_HOME}/bin/openshift-launch.sh

ADD openshift-launch.sh ${LAUNCH}
ADD jboss-config.cli ${CLI}

RUN chmod a+x ${LAUNCH} \
    && mkdir -p ${JBOSS_HOME}/prometheus \
    && curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${VERSION}/jmx_prometheus_javaagent-${VERSION}.jar \
    -o ${JBOSS_HOME}/prometheus/jmx-prometheus.jar
ADD config.yaml ${JBOSS_HOME}/prometheus/config.yaml

EXPOSE 9404