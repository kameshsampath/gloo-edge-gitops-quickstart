---
title: Envrionment Setup
summary: Setup the environment to run the quick start exercises.
authors:
  - Kamesh Sampath
date: 2021-11-21
---

At the end of this chapter you would have,

- [x] Two Kubernetes Clusters  mgmt and cluster1 on minikube
- [x] Argocd and Gitea will be installed into **mgmt** cluster
- [x] **cluster1** will act as application workload where Gloo Edge, Portal and demo applications will be installed.

## Demo Environment

The following tables shows the environment to component matrix.

| Components  | mgmt | cluster1
| ----------- | --- | ---
| Kubernetes | :material-check: | :material-check:
| Kubernetes Context Name | mgmt | cluster1
| Argocd | :material-check:| :material-close:
| Gitea | :material-check:| :material-close:
| Gloo Edge | :material-close: | :material-check:
| Gloo Portal | :material-close: | :material-check:
| Keycloak | :material-close: | :material-check:
| bookinfo | :material-check: | :material-check:
| httpbin | :material-check: | :material-check:
| keycloak | :material-check: | :material-check:
| petstore | :material-check: | :material-check:

Navigate to the `$DEMO_HOME`,

```bash
cd $DEMO_HOME
```

### Ansible Variables File

All Ansible variables used in this demo is configured using the file `vars.yml`, edit it suit your settings.

| Variable               | Description              | Default
| ---------------------- | ------------------------ | -----------|
|`work_dir`| The demo work directory | `{{ playbook_dir }}/work`. Any file in this diectory is excluded by git.
|`gcp_vpkubeconfig_dirn_name`| The kubeconfig directory | `{{ work_dir }}/.kube`
|`minikube_kubernetes_version`| The kubernetes version to use with minikube | v1.21.6
|`minikube_home_dir`| The minikube home directory | `{{ work_dir }}/.minikube` |
|`helm_version`| The helm.sh version to use| 3.7.1
|`helm_secrets_plugin_version`|  The helm secerts plugin version | 3.10.0
|`sops_version`| The sops version | 3.7.1
|`kubectl_version`| The kubectl version | 1.21.6
|`gitea_tls_cert_path`| The self signed certified to use with gitea | `{{ work_dir}}/ssl/gitea-tls.crt`
|`github_template_repo`| GitHub Template Repo | https://github.com/kameshsampath/gloo-edge-gitops-quickstart
|`argocd_app_cleanup`| Delete Argocd applictions | no
|`git_target_revision`| The Git revision to use | HEAD
|`gloo_system_namespace`| The namespce to deploy Gloo Edge | `gloo-system`
|`gloo_portal_namespace`| The namespace deploy Gloo Portal | `gloo-portal`
|`bookinfo_enabled`| The kubernetes context that will be used to query Istio resources | `no`. If `ecommerce_portal_enabled` is `yes` the bookinfo is deployed by default.
|`bookinfo_reviews_versions` | The versions of bookinfo reviews | `v1`, `v2` and `v3`
|`ecommerce_portal_enabled` | Deploy `ecommerce` demo portal application | `no`.
|`httpbin_enabled` | Deploy httpbin application | `no`. If `ecommerce_portal_enabled` is `yes` the httpbin is deployed by default.
|`gloo_portal_enabled` | Deploy Gloo portal | no
|`gloo_portal_monetization_enabled` | no
|`keycloak_enabled` | Deploy keycloak | no
|`petstore_enabled` | Deploy petstore application | `no`. If `ecommerce_portal_enabled` is `yes` the petstore is deployed by default.

The `minikube_profiles` defines the minikube cluster(s) that will be created for the demo environment,

```yaml
minikube_profiles:
  # minikube profile name and the same will used the k8s context name for this cluster
  mgmt:
    # The create minikube
    create: yes
    # The destory minikube
    destroy: no
    # The minikube addons to configure
    addons:
      - metallb
    # the metallb LoadBalancer Start IP
    lbStartIP: 192.168.64.80
    # the metallb LoadBalancer End IP
    lbEndIP: 192.168.64.90
  cluster1:
    create: yes
    destroy: no
    addons:
      - metallb
    lbStartIP: 192.168.64.100
    lbEndIP: 192.168.64.110
  cluster2:
    create: no
    destroy: no
    addons:
      - metallb
    lbStartIP: 192.168.64.120
    lbEndIP: 192.168.64.130
```

For more information on the variables check the Ansible role [minikube](https://github.com/kameshsampath/ansible-role-minikube).

The `gloo_clusters` variable by default has the following values, refer to the [component matrix](./env-setup.md#demo-environment) above to understand what this dictionary key/value represents.

```yaml
gloo_clusters:
  cluster1:
    cloud: minikube
    k8s_context: cluster1
    install_istio: yes
    cluster_name: cluster1
    enable_portal: yes
```

## Setup Kubernetes Clusters

```shell
make clusters
```

The task creates the kubernetes clusters configured using `minikube_profiles` and also downloads the compatible tools to `$DEMO_HOME/bin`.

Add the `$DEMO_HOME/bin` to your path to make sure the right versions of the tools are used,

```shell
export PATH="$DEMO_HOME/bin:$PATH"
```

## Deploy Gitea

As part of the demo we will use locally hosted [Gite](https://gitea.io) git repository,

```shell
make deploy-gitea
```

## Create age key

```shell
age-keygen -o key.txt
```

Move the `key.txt` to secure place, preferably `$HOME/.ssh`. Assuming you moved it to `$HOME/.ssh`, lets set that as local environment variables for convinience:

```bash
export SOPS_AGE_KEY_FILE="$HOME/.ssh/key.txt"
```

Also note and export the **publickey** in the `$SOPS_AGE_KEY_FILE` as `$SOPS_AGE_RECIPIENTS`

```bash
export SOPS_AGE_RECIPIENTS=$(cat $SOPS_AGE_KEY_FILE  | awk 'NR==2{ print $4}')
```

Ensure the sops configration `.sops.yml` is updated with your *age* publickey,

```shell
yq eval '.creation_rules[0].age |= strenv(SOPS_AGE_RECIPIENTS)' .sops.yml 
```

## Deploy Argocd

Argocd has to be customized to allow decrypting of secrets using the age key. The [values.yaml](./helm_vars/argocd/values.yaml) will do extra configure overrides when deploying Argocd:

- does patch the Argocd's argocd-repo-server deployment to mount the secret-keys as repo-server volume.
- install the helm plugin and age tools and make it available as `custom-tools` volumes.

We also need to make sure the age key is to be available to the Argocd repo server so that it can decrypt the secerts while deploying the resources via helm,

```shell
kubectl create ns argocd
```

```shell
kubectl create secret generic helm-secrets-private-keys \
  --namespace=argocd \
  --from-file=key.txt="$SOPS_AGE_KEY_FILE"
```

Now we are good deploy argocd by running the comand

```shell
make deploy-argocd
```
