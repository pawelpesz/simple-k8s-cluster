module "eks" {
    source       = "terraform-aws-modules/eks/aws"

    subnets         = module.vpc.private_subnets
    cluster_name    = var.cluster_name
    cluster_version = var.k8s_version

    cluster_create_timeout = "1h"
    cluster_endpoint_private_access = true 

    vpc_id = module.vpc.vpc_id

    manage_aws_auth = true
    map_users       = var.map_users

    write_kubeconfig = true

    worker_groups = [
        {
            name          = "${var.cluster_name}-workers"
            instance_type = var.instance_type
            asg_max_size  = var.cluster_size
        }
    ]

}