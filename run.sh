#!/bin/bash

set -x

results_dir="${RESULTS_DIR:-/tmp/results}"

progress_port="${SONOBUOY_PROGRESS_PORT:-8099}"

saveResults() {
    cd ${results_dir}

    # Sonobuoy worker expects a tar file.
	tar czf results.tar.gz *

	# Signal to the worker that we are done and where to find the results.
	printf ${results_dir}/results.tar.gz > ${results_dir}/done

	kubectl delete -f test/config/cluster-resources.yaml

  kubectl delete -f test/config/test-resources.yaml
}

trap saveResults EXIT

updateProgress () {
    curl -X POST http://localhost:${progress_port}/progress -d "{\"msg\":\"$1\",\"completed\":$2,\"total\":$3}"
}

echo "Creating Namespaces for Conformance testing"


kubectl apply -f test/config/cluster-resources.yaml

kubectl apply -f test/config/test-resources.yaml


export KUBECONFIG=$HOME/.kube/config

echo $KUBECONFIG

cat $KUBECONFIG


export TESTS=($(grep "func Test" test/conformance/**/*.go | awk '{print $2}' | awk -F\( '{print $1}'))

echo "Starting tests" 

len=${#TESTS[@]}

for (( i=0; i<$len; i++ ))
do
    echo "Starting Test ${TESTS[$i]} ($(echo $i+1 | bc) / $len)"
    go test -v -tags=e2e -count=1 ./test/conformance/... -run ^${TESTS[$i]}$ -disable-logstream
    updateProgress "${TESTS[$i]} Completed" $(echo $i+1 | bc) $len 
    echo "Test ${TESTS[$i]} Completed ($(echo $i+1 | bc) / $len)"
done


echo "Tests finished"