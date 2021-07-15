# Sonobouy Knative Serving E2E Conformance Tests

This repository contains a [Sonobuoy]() Plugin which allows you execute Knative Serving Conformance Tests (located here) against a Kubernetes Cluster that has Knative Serving installed. 

Install Knative Serving: 


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
