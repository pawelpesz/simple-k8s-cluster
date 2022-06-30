# Simple Kubernetes cluster
Amazon EKS cluster built with the [terraform-aws-eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) module. All _YAML_ spec files from the `deploy` directory are automatically applied to the cluster using Terraform Cloud's auto-apply feature.

## I. Prerequisites
1. Terraform Cloud account (Free or better).
2. IAM account for Terraform with `AmazonEC2FullAccess` and `AutoScalingFullAccess` policies attached. Additionally it should have the permissions defined in [`iam.json`](iam.json).
3. IAM account for `kubectl` access, doesn't need any permissions.
4. Access keys and secrets for both accounts.
5. [The `kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/#kubectl).

## II. Creating the cluster
1. Configure `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` environment variables in Terraform Cloud.
2. Configure `admin_users` variable and optionally overwrite variable defaults (like instance type, cluster size etc.).
3. Start and confirm a run.
4. Copy the `kubeconfig_b64` output variable from the Terraform Cloud's web interface into a file named `kubeconfig_simple-k8s-cluster`.
5. Verify installation with:
```
kubectl --kubeconfig=kubeconfig_simple-k8s-cluster get nodes
kubectl --kubeconfig=kubeconfig_simple-k8s-cluster get all -A
```

## III. ~~Configuring and executing GitHub workflow (obsolete)~~
1. Encode the K8s config file with `cat kubeconfig_simple-k8s-cluster | base64`.
2. Configure the following GitHub secrets:
    * `KUBE_CONFIG_DATA` - use the output from III-1.
    * `AWS_REGION` - use the same AWS region as in Terraform.
    * `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` - use credentials for the I-3 user.
3. Create a _YAML_ spec file in the `deploy` directory and push it to GitHub.
4. Verify the GitHub workflow run output.
