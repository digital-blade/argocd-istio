istioctl install

kubectl create namespace argocd
kubectl label namespace argocd istio-injection=enabled

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch -n argocd deployment argocd-server --patch-file ./argocd/argocd.deployment-patch.yaml

kubectl apply -f ./argocd/argocd.gateway.yaml
kubectl apply -f ./argocd/argocd.virtual-service.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0

kubectl wait --namespace=cert-manager --for=condition=Available Deployment/cert-manager-webhook

kubectl apply -f ./cert-manager/issuers/stage.cluster-issuer.yaml
kubectl apply -f ./cert-manager/issuers/prod.cluster-issuer.yaml

kubectl apply -f ./argocd/argocd.certificate.yaml
