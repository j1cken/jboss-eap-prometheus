# JBoss EAP - JMX Exporter Prometheus Metrics

## Build and Deploy

```
    oc new-build .
    
    oc new-app -i jboss-eap-prometheus --name=app
```

## Create OpenShift Docker Strategy Build

```
$ oc new-build https://github.com/j1cken/jboss-eap-prometheus\#7.1 --name eap71-openshift-prometheus --strategy='docker' -n openshift                
```

## Enable OpenShift Discovery

Make sure to add your namespace patterns (or a unique one like **eap-ftw** below) to the regex of the kubernetes-service-endpoints job config otherwise your service will not be discovered if it doesn't match the given pattern. Prometheus config is provided by a config map called *prometheus*:

```
$ oc get cm -n openshift-metrics           
NAME           DATA      AGE
alertmanager   1         3h
prometheus     2         3h
```

Look for *kubernetes-service-endpoints*:

```
- job_name: 'kubernetes-service-endpoints'

  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    # TODO: this should be per target
    insecure_skip_verify: true

  kubernetes_sd_configs:
  - role: endpoints

  relabel_configs:
    # only scrape infrastructure components
    - source_labels: [__meta_kubernetes_namespace]
      action: keep
      regex: 'default|metrics|kube-.+|openshift|openshift-.+|eap-ftw'
```

And in case you are using *ovs-multitenant* SDN plugin make sure the default prometheus namespace *openshift-metrics* is able to talk to your project:

```
$ oc adm pod-network join-projects --to=eap-ftw openshift-metrics
```

## Active JMX Exporter
    
```
    export JBOSS_HOME=/opt/eap
    oc set env dc/app PREPEND_JAVA_OPTS="-javaagent:${JBOSS_HOME}/prometheus/jmx-prometheus.jar=9404:${JBOSS_HOME}/prometheus/config.yaml"
    
    oc annotate svc/app prometheus.io/scrape='true'
    oc annotate svc/app prometheus.io/port='9404'
   
```

## Check the targets in Prometheus

url: https://prometheus-openshift-metrics.example.org/targets

![](images/service-target.png)

# Reference

* https://github.com/prometheus/jmx_exporter

