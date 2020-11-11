#!/bin/bash -xe

REPO_NAMESPACE=${1:-default}
OC_OPTS="--ignore-not-found=true"

for i in svc deploy route; do
    oc delete $i helm-tls-repo -n $REPO_NAMESPACE $OC_OPTS
done

oc delete configmap helm-tls-repo-ca -n openshift-config $OC_OPTS
oc delete secret helm-tls-repo -n openshift-config $OC_OPTS

oc delete helmchartrepository.helm.openshift.io/test-repo $OC_OPTS
