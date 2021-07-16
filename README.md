# Sonobouy Knative Serving E2E Conformance Tests

This repository contains a [Sonobuoy]() Plugin which allows you execute Knative Serving Conformance Tests (located here) against a Kubernetes Cluster that has Knative Serving installed. 

Install Knative Serving: [https://knative.dev/docs/admin/install/serving/install-serving-with-yaml/](https://knative.dev/docs/admin/install/serving/install-serving-with-yaml/)


In order to run this plugin you need to download and install Sonobuoy and then run:

```
sonobuoy run --plugin sonobuoy-knative-serving.yaml
```

Check status and completed tests
```
sonobuoy status --json | jq 
```

Download results: 

```
outfile=$(sonobuoy retrieve) && \                                         
mkdir results && tar -xf $outfile -C results
```

This Sonobuoy Plugin uses a Docker image that can be found here: [https://hub.docker.com/repository/docker/salaboy/knative-serving-conformance](https://hub.docker.com/repository/docker/salaboy/knative-serving-conformance). This Docker Image was built based on the main branch of the Knative Serving repository (15th July 2021) and it uses the Dockerfile located in this repository plus the `run.sh` script that is in charge or executing each individual test and report back to sonobuoy for progress. This script is not checking for PASS or FAIL yet. But at least, sonobuoy understand how many tests were executed so far.  
