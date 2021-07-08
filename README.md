# Simple Kubernetes cluster
Amazon EKS cluster built with the [terraform-aws-eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) module. All _YAML_ spec files pushed into the `deploy` directory are automatically applied to the cluster using a GitHub workflow.

## I. Prerequisites
1. Terraform >= 1.0.
2. IAM account for Terraform with [appropriate permissions](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md).
3. IAM account for `kubectl` access, doesn't need any permissions.
4. Access keys and secrets for both accounts.
6. [The `kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/#kubectl).

## II. Creating the cluster
1. Configure `aws_access_key_id`, `aws_secret_access_key` (use credentials for the I-2 user) and `admin_users` in `terraform.tfvars` file.
2. Optionally override the defaults from `variables.tf` in `terraform.tfvars` file.
3. Run `terraform init`.
4. Run `terraform apply -auto-approve`.
5. The Kubernetes config file is created as `kubeconfig_simple-k8s-cluster`.
6. Verify installation with `kubectl --kubeconfig=kubeconfig_simple-k8s-cluster get nodes`.

## III. Configuring GitHub action
1. Encode the K8s config file with `cat kubeconfig_simple-k8s-cluster | base64`.
2. Configure the following GitHub secrets:
    * `KUBE_CONFIG_DATA` - use the output from III-1.
    * `AWS_REGION` - use the same AWS region as in Terraform.
    * `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` - use credentials for the I-3 user.
3. Create a _YAML_ spec file in the `deploy` directory and push it to GitHub.
4. Verify the GitHub workflow run output.