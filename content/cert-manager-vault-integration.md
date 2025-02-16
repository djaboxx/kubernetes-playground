# Integrating Cert-Manager with HashiCorp Vault in a Kubernetes Cluster

This document provides a comprehensive guide on how to integrate Cert-Manager with HashiCorp Vault in a Kubernetes cluster. This integration allows for the automatic issuance and renewal of TLS certificates using Vault as the Certificate Authority (CA).

## Prerequisites

- A running Kubernetes cluster
- Cert-Manager installed in the cluster
- HashiCorp Vault installed and configured
- kubectl configured to interact with the cluster

## Step 1: Install Cert-Manager

If Cert-Manager is not already installed, you can install it using Helm:

```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
```

## Step 2: Configure Vault

1. **Enable the PKI secrets engine:**

    ```sh
    vault secrets enable pki
    vault secrets tune -max-lease-ttl=8760h pki
    ```

2. **Generate the root certificate:**

    ```sh
    vault write -field=certificate pki/root/generate/internal common_name="example.com" ttl=8760h > CA_cert.crt
    ```

3. **Configure the CA and CRL URLs:**

    ```sh
    vault write pki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"
    ```

4. **Create a role for Cert-Manager:**

    ```sh
    vault write pki/roles/example-dot-com allowed_domains="example.com" allow_subdomains=true max_ttl="72h"
    ```

## Step 3: Configure Cert-Manager to Use Vault

1. **Create a Kubernetes secret with Vault credentials:**

    ```sh
    kubectl create secret generic vault-token --from-literal=token=<VAULT_TOKEN> --namespace cert-manager
    ```

2. **Create an Issuer or ClusterIssuer resource:**

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: vault-issuer
    spec:
      vault:
        server: "http://127.0.0.1:8200"
        path: "pki/sign/example-dot-com"
        auth:
          tokenSecretRef:
            name: vault-token
            key: token
    ```

    Apply the resource:

    ```sh
    kubectl apply -f issuer.yaml
    ```

## Step 4: Request a Certificate

1. **Create a Certificate resource:**

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: example-com
      namespace: default
    spec:
      secretName: example-com-tls
      issuerRef:
        name: vault-issuer
        kind: ClusterIssuer
      commonName: example.com
      dnsNames:
      - example.com
    ```

    Apply the resource:

    ```sh
    kubectl apply -f certificate.yaml
    ```

## Using PKI Secrets Endpoint in Vault

To use the PKI secrets endpoint in Vault from a pod or service in Kubernetes, follow these steps:

1. **Create a Kubernetes Service Account for Vault Access:**

    ```sh
    kubectl create serviceaccount vault-auth
    ```

2. **Bind the Service Account to a Role with Appropriate Permissions:**

    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: vault-role
      namespace: default
    rules:
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["get"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: vault-rolebinding
      namespace: default
    subjects:
    - kind: ServiceAccount
      name: vault-auth
      namespace: default
    roleRef:
      kind: Role
      name: vault-role
      apiGroup: rbac.authorization.k8s.io
    ```

    Apply the Role and RoleBinding:

    ```sh
    kubectl apply -f role.yaml
    kubectl apply -f rolebinding.yaml
    ```

3. **Configure Vault Kubernetes Auth Method:**

    ```sh
    vault auth enable kubernetes
    vault write auth/kubernetes/config \
        token_reviewer_jwt="$(kubectl get secret $(kubectl get serviceaccount vault-auth -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)" \
        kubernetes_host="$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[0].cluster.server}')" \
        kubernetes_ca_cert="$(kubectl get secret $(kubectl get serviceaccount vault-auth -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data['ca.crt']}' | base64 --decode)"
    ```

4. **Create a Role in Vault for the Kubernetes Service Account:**

    ```sh
    vault write auth/kubernetes/role/example-role \
        bound_service_account_names=vault-auth \
        bound_service_account_namespaces=default \
        policies=default \
        ttl=1h
    ```

5. **Deploy a Pod that Uses the Vault PKI Secrets Endpoint:**

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: vault-pki-example
      namespace: default
    spec:
      serviceAccountName: vault-auth
      containers:
      - name: vault-pki-example
        image: alpine
        command: ["/bin/sh"]
        args: ["-c", "apk add --no-cache curl && curl --header \"X-Vault-Token: $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)\" --request POST --data '{\"common_name\":\"example.com\"}' http://127.0.0.1:8200/v1/pki/issue/example-dot-com"]
    ```

    Apply the Pod configuration:

    ```sh
    kubectl apply -f pod.yaml
    ```

## Additional Resources

For more detailed information, refer to the following resources:

- [Vault Documentation](https://www.vaultproject.io/docs)
- [Terraform Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)

## Example Terraform Configuration

Here is an example of how to configure Vault to work with Cert-Manager using Terraform:

```hcl
resource "vault_auth_backend" "example" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "example" {
  backend   = vault_auth_backend.example.path
  role_name = "example-role"
  policies  = ["default"]
}

resource "vault_kv_secret_v2" "example" {
  backend = "secret"
  path    = "example"
  data_json = jsonencode({
    foo = "bar"
  })
}

resource "vault_pki_secret_backend" "pki" {
  path = "pki"
}

resource "vault_pki_secret_backend_config_urls" "pki" {
  backend = vault_pki_secret_backend.pki.path
  issuing_certificates = "http://127.0.0.1:8200/v1/pki/ca"
  crl_distribution_points = "http://127.0.0.1:8200/v1/pki/crl"
}

resource "vault_pki_secret_backend_role" "example" {
  backend = vault_pki_secret_backend.pki.path
  name    = "example-dot-com"
  allowed_domains = ["example.com"]
  allow_subdomains = true
  max_ttl = "72h"
}
```

## Conclusion

By following these steps, you have successfully integrated Cert-Manager with HashiCorp Vault in your Kubernetes cluster. This setup allows for the automatic issuance and renewal of TLS certificates using Vault as the Certificate Authority (CA).

For more detailed information, refer to the [Vault Documentation](https://www.vaultproject.io/docs) and the [Terraform Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs).