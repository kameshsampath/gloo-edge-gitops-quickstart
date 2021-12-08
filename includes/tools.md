# Download Tools

We will be using the following tools as part of the tutorial. Please have them installed and configured before proceeding further.

| Tool      | macos                          | linux | windows|
| ----------- | ----------- |  ----------- | ----------- |
| [minikube](https://minikube.sigs.k8s.io/docs/){target=_blank}^*^| `brew install minikube` | [Install](https://minikube.sigs.k8s.io/docs/start/) | [Install](https://minikube.sigs.k8s.io/docs/start/)
|[helm](https://helm.sh){target=_blank}^*^| `brew install helm`|[Install](https://helm.sh/docs/intro/install/){target=_blank}|`choco install kubernetes-helm`
|[yq v4](https://github.com/mikefarah/yq){target=_blank}^*^|`brew install yq`|[Download](https://github.com/solo-io/gloo/releases/download/v1.8.10/glooctl-linux-amd64)|[Download](https://github.com/solo-io/gloo/releases/download/v1.8.10/glooctl-windows-amd64.exe)
|[jq](https://stedolan.github.io/jq/){target=_blank}|`brew install jq`|[Install](https://github.com/mikefarah/yq#linux-via-snap){target=_blank}|`choco install yq`
|[pipx](https://pypa.github.io/pipx/){target=_blank}^*^|`brew install pipx && pipx ensurepath`|`python3 -m pip install --user pipx && python3 -m pipx ensurepath`|`python3 -m pip install --user pipx && python3 -m pipx ensurepath`
|[kubectl](https://kubectl.docs.kubernetes.io){target=_blank}^*^|`brew install kubectl`|[Download](https://kubectl.docs.kubernetes.io/installation/kubectl/binaries/){target=_blank}|`choco install kubernetes-cli`
|[kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/){target=_blank}^*^|`brew install kustomize`|[Download](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/){target=_blank}|`choco install kustomize`
|[stern](https://github.com/wercker/stern){target=_blank}|`brew install stern`|[Download](https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64){target=_blank}|[Download](https://github.com/wercker/stern/releases/download/1.11.0/stern_windows_amd64.exe){target=_blank}
|[sops](https://github.com/mozilla/sops){target=_blank}|`brew install sops`|[Download](https://github.com/mozilla/sops#11stable-release){target=_blank}|[Install](https://github.com/mozilla/sops#11stable-release){target=_blank}
|[age](https://github.com/mozilla/sops){target=_blank}|`brew install age`|[Install](https://github.com/FiloSottile/age#installation){target=_blank}|[Install](https://github.com/FiloSottile/age#installation){target=_blank}
|[httpie](https://httpie.io)|[Install](https://httpie.io/cli)|[Install](https://httpie.io/cli)|[Install](https://httpie.io/cli){target=_blank}

!!!note
    * Marked ^*^ are required tools
    *  You will need Gloo Edge Enterprise License Key to run the some of the advanced features of Gloo Edge. If you dont have one, get a trial license from [solo.io](https://lp.solo.io/request-trial).
