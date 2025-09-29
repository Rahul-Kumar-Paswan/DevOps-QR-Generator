## 🔑 What You Need for AWS Secrets Manager in Kubernetes

### IAM Role with Permissions:

Your EKS nodes or service account must have permissions:

``` bash {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
}
```

## Secrets Store CSI Driver Installed:

### Install via Helm:
``` bash
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo update
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system
```


## Secret in AWS Secrets Manager:

### Create a secret named qr-generator-aws-creds with keys:

``` bash
{
  "AWS_ACCESS_KEY": "your-access-key",
  "AWS_SECRET_KEY": "your-secret-key"
}
```

## Kubernetes Integration

SecretProviderClass (secret-provider.yaml) → maps the AWS secret to a volume in your pod.

ServiceAccount (service-account.yaml) → associate IAM role if using IRSA (recommended).
