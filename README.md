# Gloo Edge GitOps Quickstart

- Install pipx
- Install poetry

```
pipx install poetry 
poetry config  virtualenvs.in-project true
```

## Required tools

The demo requires the following tools, have them installed and added to `$PATH` before proceeding with the demo,

- [sops](https://github.com/mozilla/sops)
- [age](https://github.com/FiloSottile/age)
- [Argocd](https://argo-cd.readthedocs.io)
- [yq](https://github.com/mikefarah/yq)
- [Hashicorp Vault](https://www.vaultproject.io)
- [Helm](https://helm.sh/docs/intro/install/)
- [minikube](https://minikube.sigs.k8s.io/docs/)

## Ansible Environment

Create Ansible pythonenv

```shell
make create-venv
```

## Kubernetes Cluster

Setup minikube cluster and infrastructure components

```shell
make clusters
```

## Deploy Gitea

Deploy gitea,

```shell
make deploy-gitea
```

## Setup Demo repository in gitea

```shell
git clone https://github.com/kameshsampath/gloo-edge-gitops-quickstart
cd gloo-edge-gitops-quickstart
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

We need to make the age key to be available to the Argocd repo server so that it can decrypt the secrets,

```shell
kubectl create ns argocd
```

```shell
kubectl create secret generic helm-secrets-private-keys \
  --namespace=argocd \
  --from-file=key.txt="$SOPS_AGE_KEY_FILE"
```

## Deploy Argocd

Deploy gitea,

```shell
make deploy-argocd
```

__NOTE__:
	
	The [values.yaml](./helm_vars/argocd/values.yaml)

	- does patch the Argocd's argocd-repo-server deployment to mount the secret-keys as repo-server volume
	- install the helm plugin and age tools and make it available as `custom-tools` volumes
