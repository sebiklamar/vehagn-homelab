# Kubernetes Tofu

```shell
openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout bootstrap/sealed-secrets/certificate/sealed-secrets.key -out bootstrap/sealed-secrets/certificate/sealed-secrets.cert -subj "/CN=sealed-secret/O=sealed-secret"

vi credentials.auto.tfvars

tofu init
tofu apply -target=module.talos.talos_image_factory_schematic.this
tofu apply

talosctl config merge output/talos-config.yaml

CLUSTER="talos"; kubectl config delete-context admin@$CLUSTER; kubectl config delete-user admin@$CLUSTER; kubectl config delete-cluster $CLUSTER

cp ~/.kube/config ~/.kube/config.bak && KUBECONFIG="~/.kube/config:output/kube-config.yaml" kubectl config view --flatten > /tmp/config && mv /tmp/config ~/.kube/config
```