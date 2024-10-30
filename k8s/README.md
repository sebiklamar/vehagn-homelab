# Manual bootstrap

## CRDs

Gateway API

```shell
kubectl apply -k infra/crds
```

## Cilium

```shell
kubectl kustomize --enable-helm infra/network/cilium | kubectl apply -f -
```

## Sealed-secrets

```shell
kustomize build --enable-helm infra/controllers/sealed-secrets | kubectl apply -f -
```

```shell
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o yaml >mysecret.yaml

 echo -n test2 | kubectl create secret generic cloudflare-api-token --dry-run=client --from-file=api-token=/dev/stdin -o yaml | kubeseal --controller-namespace sealed-secrets -o yaml -n cert-manager --merge-into infra/controllers/cert-manager/cloudflare-api-token.yaml
 echo -n my-tunnel-secret | kubectl create secret generic tunnel-credentials --dry-run=client --from-file=credentials.json=/dev/stdin -o yaml | kubeseal --controller-namespace sealed-secrets -o yaml -n cloudflared --merge-into infra/network/cloudflared/tunnel-credentials.yaml
 cat ~/.cloudflared/da8acdd7-2646-4d2b-bec5-c147b03c05fa.json | kubectl create secret generic tunnel-credentials --dry-run=client --from-file=credentials.json=/dev/stdin -o yaml | kubeseal --controller-namespace sealed-secrets -o yaml -n cloudflared --merge-into ~/src/vehagn-homelab/k8s/infra/network/cloudflared/tunnel-credentials.yaml

cat users.yaml | kubectl create secret generic users --dry-run=client --from-file=users.yaml=/dev/stdin -o yaml | kubeseal --controller-namespace sealed-secrets -o yaml -n dns --merge-into infra/network/dns/adguard/secret-users.yaml

# test
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets < infra/controllers/cert-manager/cloudflare-api-token.yaml --recovery-unseal --recovery-private-key sealed-secrets-key.yaml -o json | jq -r ' .data."api-token" | @base64d'
```

## Proxmox CSI Plugin

```shell
kustomize build --enable-helm infra/storage/proxmox-csi | kubectl apply -f -
```

```shell
kubectl get csistoragecapacities -ocustom-columns=CLASS:.storageClassName,AVAIL:.capacity,ZONE:.nodeTopology.matchLabels -A
k get -A pv
```

## Argo CD

```shell
kustomize build --enable-helm infra/controllers/argocd | kubectl apply -f -
```

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -ojson | jq -r ' .data.password | @base64d'
```

```shell
kubectl apply -k infra
```

```shell
kubectl apply -k sets
```

# SBOM

* [x] Cilium
* [X] Hubble
* [x] Argo CD
* [x] Proxmox CSI Plugin
* [x] Cert-manager
* [X] Gateway
* [X] Authentication (Keycloak, Authentik, ...)
* [] CNPG - Cloud Native PostGresSQL

# CRDs

* [] Gateway
* [] Argo CD
* [] Sealed-secrets

# TODO

* [X] Remotely managed cloudflared tunnel
* [X] Keycloak
* [] Argo CD sync-wave

```shell
commonAnnotations:
    argocd.argoproj.io/sync-wave: "-1"
```
