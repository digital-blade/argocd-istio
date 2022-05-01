# ArgoCD behind istio installation
This repository will help to deploy ArgoCD behind istio.

Just modify email in ClusterIssuer and domain in Certificate, Gateway and VirtualService.
After this run `./install.sh`

## How it works
1. `istioctl install` installs istio service-mesh
2. Then installs ArgoCD into corresponding workspace `argocd` and with istio auto-injection
3. Applies deployment patch for `argocd-server` to enable insecure mode
4. Creates ClusterIssuers, Gateway and Certificate.

After installation complete it's necessary to enable https redirect on created gateway.
It is not set by default because it is necessary to perform ACME challenge.

## istio-init troubleshoot
> istio use iptables to intercept traffic, by adding nat rules.
> Linux should enable netfix linux kernel modules.
> In all hosts do the command to enable.
```shell
modprobe br_netfilter;
modprobe nf_nat;
modprobe xt_REDIRECT;
modprobe xt_owner;
modprobe iptable_nat;
modprobe iptable_mangle;
modprobe iptable_filter
```

## Bonus
To enable OAuth through GitHub, you should apply `argocd-dex.deployment-patch` and write the following lines in ArgoCD-ConfigMap

```shell
kubectl apply -f argocd/argocd-dex.deployment-patch.yaml
kubectl edit configmap argocd-cm -n argocd
```

```yaml
data:
  url: https://argo.example.com

  dex.config: |
    connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: $CLIENT_ID
          clientSecret: $CLIENT_SECRET
          orgs:
          - name: some-org
```
### Important!
Do not forget create secret `github-oauth` with fields `clientId` and `clientSecret`.