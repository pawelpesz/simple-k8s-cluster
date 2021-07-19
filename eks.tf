data "aws_caller_identity" "current" { }

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 17.1"

    vpc_id          = module.vpc.vpc_id
    subnets         = module.vpc.private_subnets
    cluster_name    = var.cluster_name
    cluster_version = var.k8s_version

    cluster_create_timeout = "1h"
    cluster_endpoint_private_access = true 

    manage_aws_auth = true
    map_users       = [
        for user in var.admin_users:
            {
                userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
                username = "${user}"
                groups   = [ "system:masters" ]
            }
    ]

    write_kubeconfig = true

    worker_groups = [
        {
            name                 = "${var.cluster_name}-workers"
            instance_type        = var.instance_type
            asg_desired_capacity = var.cluster_size
        }
    ]

}