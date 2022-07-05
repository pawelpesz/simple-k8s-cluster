# Simple Kubernetes cluster
Amazon EKS cluster built with the [terraform-aws-eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) module. All _YAML_ spec files from the `deploy` directory are automatically applied to the cluster using Terraform Cloud's auto-apply feature.

Some of the example manifests are sourced from:
* https://github.com/kubernetes/website/tree/main/content/en/examples/application/nginx
* https://github.com/kubernetes/dashboard/tree/master/aio/deploy
* https://github.com/kubernetes/dashboard/tree/master/docs/user/access-control
* https://github.com/kubernetes-sigs/metrics-server

## I. Prerequisites
1. Terraform Cloud account (Free or better).
2. IAM account for Terraform with `AmazonEC2FullAccess` and `AutoScalingFullAccess` policies attached. Additionally it should have the permissions defined in [`iam.json`](iam.json).
3. IAM account for `kubectl` access, doesn't need any permissions.
4. Access keys and secrets for both accounts.
5. [Terraform CLI](https://www.terraform.io/downloads).
6. [The `kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/#kubectl).

## II. Creating the cluster
1. Configure `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` environment variables in Terraform Cloud.
2. Configure `admin_users` variable and optionally overwrite variable defaults (like instance type, cluster size etc.).
3. Start and confirm a run.
4. Sometimes the initial run fails when creating the `coredns` add-on, if it does, just fire another one.

## III. Verification
1. Use the Terraform CLI to generate the `kubeconfig` file:
```
terraform output -raw kubeconfig > kubeconfig_simple-k8s-cluster
```
2. List nodes, pods and other principal K8s objects:
```
export KUBECONFIG=$(pwd)/kubeconfig_simple-k8s-cluster
kubectl get nodes
kubectl get all -A
```
3. Connect to the Kubernetes Dashboard:
    * Copy the authorization token retrieved by running:
    ```
    kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') -o=jsonpath='{.data.token}'
    ```
    * Run K8s proxy:
    ```
    kubectl proxy
    ```
    * Connect to the dashboard, use the token to log in:
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
