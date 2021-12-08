---
title: Envrionment Setup
summary: Setup the environment.
authors:
  - Kamesh Sampath
date: 2021-11-21
---

At the end of this chapter you would have,

- [x] Ansible environment to run the playbooks
- [x] Two Kubernetes Clusters  mgmt and cluster1 on minikube
- [x] Argocd and Gitea will be installed into **mgmt** cluster
- [x] **cluster1** will act as application workload with Gloo Edge and Portal, Pipelines are installed as part of the setup

## Ansible Environment

To create the virutal environment run the following command,

```shell
make create-venv
```

The command will instal all the required python modules in the `$DEMO_HOME/.venv`.

Install the [ansible roles and collections](./ansible.md) that will be used by the playbooks,

```bash
make install-roles-and-collections
```

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

Navigate to the `$DEMO_HOME`,

```bash
cd $DEMO_HOME
```

### Ansible Variables File

All Ansible variables used in this quickstart is configured using the file `$DEMO_HOME/vars.yml`, be sure edit them suit your settings.

| Variable               | Description              | Default
| ---------------------- | ------------------------ | -----------|
|`work_dir`| The demo work directory | `{{ playbook_dir }}/work`. Any file in this diectory is excluded by git.
|`kubeconfig_dir`| The directory where the kubeconfig files the minikube clusters will be stored.  | `{{ work_dir }}/.kube`. Any file in this diectory is excluded by git.
|`minikube_kubernetes_version`| The kubernetes version to use with minikube | v1.21.6
|`minikube_home_dir`| The minikube home directory | `{{ work_dir }}/.minikube` |
|`helm_version`| The helm.sh version to use| 3.7.1
|`helm_secrets_plugin_version`|  The helm secerts plugin version . This is just added to enable using Helm Secrets| 3.10.0
|`sops_version`| The sops version. This added to be used with Helm Secrets | 3.7.1
|`kubectl_version`| The kubectl version | 1.21.6
|`gitea_tls_cert_path`| The self signed certified to use with gitea | `{{ work_dir}}/ssl/gitea-tls.crt`
|`kubernetes_spices_gitea_k8s_context`| The kubernetetes context where Gitea will be installed | `mgmt`
|`kubernetes_spices_argocd_k8s_context`| The kubernetetes context where Argocd will be installed | `mgmt`
|`kubernetes_spices_tektoncd_k8s_context`| The kubernetetes context where tektoncd will be installed | `mgmt`
|`enable_portal_monetization`| Enabe Portal monetization| `yes`

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

For more information on the variables check the Ansible role [minikube](https://kameshsampath.github.io/ansible-role-minikube/){target=_blank}.

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

## Quickstart `vars.yml`

```yaml
---8<--- "vars.yml"
```


## Setup Kubernetes Clusters

```shell
make create-kube-clusters
```

The task creates the kubernetes clusters configured using `minikube_profiles` and also downloads the compatible tools to `$DEMO_HOME/bin`.

Add the `$DEMO_HOME/bin` to your path to make sure the right versions of the tools are used,

```shell
export PATH="$DEMO_HOME/bin:$PATH"
```

## Deploy Gitea

Deploy minkube hosted [Gitea](https://gitea.io) git repository for working with GitOps,

```shell
make deploy-gitea
```

## Deploy Argocd

Deploy [argocd](https://argoproj.github.io) for enabling continious delivery using GitOps,

```shell
make deploy-argocd
```

## Deploy Pipelines

Deploy [tektoncd](https://tekton.dev) for enabling Kubernetes native pipelines,

```shell
make deploy-pipelines
```

## Deploy Gloo Edge

```shell
make deploy-gloo
```
