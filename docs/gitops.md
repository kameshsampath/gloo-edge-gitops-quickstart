---
title: Gloo Apps
summary: Deploy Gloo Edge and Portal using Argocd
authors:
  - Kamesh Sampath<kamesh.sampath@hotmail.com>
date: 2021-11-21
---

At the end of this chapter you would have deployed Gloo Edge and Gloo Portal via Gitops with Argocd.

## Ensure Enviroment

Ensure the following enviroment variables are set before proceeding further,

```shell
export DEMO_HOME="${PWD}"
export DEMO_WORK_DIR="${DEMO_HOME}/work"

# GLOO
export GLOO_EDGE_LICENSE_KEY="Your Gloo Edge Enterpise License"

export GITEA_USERANAME="gitea"
export GITEA_PASSWORD=$(cat "${DEMO_WORK_DIR}/gitea_passwordfile")
export GITEA_SELFSIGNED_CA="$DEMO_WORK_DIR/ssl/gitea-tls.crt"

# Kubernetes context name of Gloo Mesh Cluster that will have management components installed
export MGMT=mgmt
export CLUSTER1=cluster1
export CLUSTER2=cluster2

export KUBECONFIG="${DEMO_WORK_DIR}/.kube/config"

export PATH="${DEMO_HOME}/bin:$PATH"
# as we will be using self signed certs for Gitea
export GIT_SSL_NO_VERIFY=true

export MINIKUBE_HOME="${DEMO_WORK_DIR}/.minikube"
export MINIKUBE_DRIVER=hyperkit

export ARGOCD_VERSION=v2.1.6

export SOPS_AGE_KEY_FILE=~/.ssh/sops_dev_key.txt
export SOPS_AGE_RECIPIENTS=$(cat $SOPS_AGE_KEY_FILE  | awk 'NR==2{ print $4}')
```

!!! tip
  You can tools like [direnv](https://direnv.net/) to configure and load the environment variables.

## Prepare Gloo Deployment

The Gloo Licensekey is configured using helm values file `$DEMO_HOME/infrastructure/gloo/edge/secrets.yaml`,

Copy the `$DEMO_HOME/infrastructure/gloo/edge/secrets-example.yaml` to `$DEMO_HOME/infrastructure/gloo/edge/secrets.yaml`

```shell
cp `$DEMO_HOME/infrastructure/gloo/edge/secrets-example.yaml` `$DEMO_HOME/infrastructure/gloo/edge/secrets.yaml`
```

Update the Gloo Edge license key match your license key in the `secrets.yaml`, if you have configured the `$GLOO_EDGE_LICENSE_KEY` then its as simple as running,

```shell
yq eval '.gloo-ee.license-key |= strenv(GLOO_EDGE_LICENSE_KEY)' $DEMO_HOME/infrastructure/gloo/edge/secrets.yaml
```

Now encrypt the `$DEMO_HOME/infrastructure/gloo/edge/secrets.yaml` so that its safe to be pushed into the Gitea or other Git repositories that are used as part of your GitOps setup.

```shell
helm secrets enc $DEMO_HOME/infrastructure/gloo/edge/secrets.yaml
```

!!! note
    The helm charts uses the Helm sub-chart pattern configure Gloo Helm Values. So when adding any other Gloo Helm values make sure to add below the sub chart name `gloo-ee`

## Deploy Gloo Edge

Now run the following command:

```shell
make deploy-argocd-apps
```

## Deploy Gloo Portal

Edit the `$DEMO_HOME/vars.yml` to update the `gloo_portal_enabled` variable to `yes` and run the following command,

```shell
make deploy-argocd-apps
```

!!! tip
  You can also do
  ```shell
    EXTRA_VARS="-gloo_portal_enabled=yes" make deploy-argocd-apps
  ```

## Deploy Keycloak

The Keycloak deployment helm values are controlled using `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml` and `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml`

Copy the `$DEMO_HOME/helm_vars/keycloak/values/secrets-example.yaml` to `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml`

```shell
cp `$DEMO_HOME/helm_vars/keycloak/values/secrets-example.yaml` `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml`
```

Edit and update the `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml` for `keycloakAdminUser` and `keycloakAdminPassword` values,

Now encrypt the `$DEMO_HOME/helm_vars/keycloak/values/secrets.yaml` so that its safe to be pushed into the Gitea or other Git repositories that are used as part of your GitOps setup.

```shell
helm secrets enc $DEMO_HOME/helm_vars/keycloak/values/secrets.yaml
```

Once you have created keycloak secerts, edit the `$DEMO_HOME/vars.yml` to update the `keycloak_enabled` variable to `yes` and run the following command,

```shell
make deploy-argocd-apps
```
