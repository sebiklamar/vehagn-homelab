# Kubernetes Tofu

```shell
openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout bootstrap/sealed-secrets/certificate/sealed-secrets.key -out bootstrap/sealed-secrets/certificate/sealed-secrets.cert -subj "/CN=sealed-secret/O=sealed-secret"

tofu output -raw kube_config
tofu output -raw talos_config
```