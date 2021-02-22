# Sample Helm Repository secured with TLS

## Environment

Mandatory:
* `QUAY_USERNAME` - image registry username
* `QUAY_PASSWORD` - image registry password

Optional:
* `CE` - container engine (`podman` or `docker`) to be used - default is `podman`
* `DOMAIN` - an application domain within OpenShift:
  * usually something like `apps.<cluster_name>.<base_domain>` in case of OpenShift Online
  * by default it is auto-detected by running the following command `oc get route console -n openshift-console -o jsonpath='{.status.ingress[0].routerCanonicalHostname}'`
* `REPO_NAMESPACE` - namespace to deploy Helm Repo - default is `default`
* `REPO_IMAGE` - Helm Repo Image - default is `quay.io/$QUAY_USERNAME/helm-tls-repo`

## Usage

To deploy Helm Repo secured with TLS into OpenShift:

[`$ ./deploy.sh`](./deploy.sh)

To undeploy Helm Repo from OpenShift:

[`$ ./undeploy.sh`](./undeploy.sh)

To clean locally generated files:

[`$ ./clean.sh`](./clean.sh)
