# Sonobouy Knative Serving E2E Conformance Tests

This repository contains a [Sonobuoy]() Plugin which allows you execute Knative Serving Conformance Tests (located here) against a Kubernetes Cluster that has Knative Serving installed. 

For more details visit the following [Blog Post](https://salaboy.com/2021/07/23/knative-oss-diaries-week-3/)

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


# Creating the plugin

With the `Dockerfile` and `run.sh` file inside a clone of Knative Serving run: 

```
docker build -t <user>/knative-serving-conformance:v.0.0.x .
docker push <user>/knative-serving-conformance:v.0.0.x .
```



```
sonobuoy gen plugin \
--name=knative-serving-conformance \
--image salaboy/knative-serving-conformance:v0.0.21 > hello-world.yaml
```
