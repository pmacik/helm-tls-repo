#!/bin/bash -xe

CE=${CE:-podman}

set +x
QUAY_USERNAME=${QUAY_USERNAME:-}
QUAY_PASSWORD=${QUAY_PASSWORD:-}
echo -n ${QUAY_PASSWORD} | $CE login quay.io -u ${QUAY_USERNAME} --password-stdin
set -x

DOMAIN=${DOMAIN:-$(oc get route console -n openshift-console -o jsonpath='{.status.ingress[0].routerCanonicalHostname}')}
REPO_HOST=htr.$DOMAIN
REPO_NAMESPACE=${REPO_NAMESPACE:-default}
REPO_IMAGE=${REPO_IMAGE:-quay.io/$QUAY_USERNAME/helm-tls-repo}

# Extract CA
oc get secret signing-key -n openshift-service-ca -o json | jq -rc '.data."tls.key"' | base64 --decode >ca-bundle.key 
oc get secret signing-key -n openshift-service-ca -o json | jq -rc '.data."tls.crt"' | base64 --decode >ca-bundle.crt ## needs to be named this way for 'helm-tls-repo-ca' config map used by HCR

# Helm Repo App
sed -e "s,@@DOMAIN@@,$DOMAIN,g" ssl_server.template.conf > ssl_server.conf

openssl genrsa -out server.key 2048
openssl req -new -key server.key -config ssl_server.conf -out server.csr
openssl x509 -req -in server.csr -days 365 -sha256 -CAcreateserial -CA ca-bundle.crt -CAkey ca-bundle.key -out server.crt

## Build Helm Repo App
$CE build -t $REPO_IMAGE -f Dockerfile .
$CE push $REPO_IMAGE

## Deploy Helm Repo App
oc apply -f helm-tls-repo.deployment.yaml
oc expose deployment helm-tls-repo

# Expose Helm Repo App over HTTPS
oc create route edge --service=helm-tls-repo --cert=server.crt --key=server.key --hostname=$REPO_HOST -n $REPO_NAMESPACE

# Prepare TLS config for HCR
oc create secret tls helm-tls-repo --cert=server.crt --key=server.key -n openshift-config
oc create configmap helm-tls-repo-ca -n openshift-config
oc set data configmap helm-tls-repo-ca -n openshift-config --from-file=ca-bundle.crt

# Create HCR
sed -e "s,REPO_HOST,$REPO_HOST,g" hcr.yaml | oc apply -f -
