kubectl delete -f ./argocd/argocd.certificate.yaml

kubectl delete -f ./cert-manager/issuers/prod.cluster-issuer.yaml
kubectl delete -f ./cert-manager/issuers/stage.cluster-issuer.yaml

helm --namespace cert-manager delete cert-manager
kubectl delete namespace cert-manager

kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

kubectl delete -n argocd -f ./argocd/argocd.gateway.yaml
kubectl delete -n argocd -f ./argocd/argocd.virtual-service.yaml

kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl delete namespace argocd

istioctl x uninstall --purge
