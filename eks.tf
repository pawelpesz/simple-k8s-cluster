data "aws_caller_identity" "current" {}

# See: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/0a17f655fb7da00640627ed9255f1d96e42fcfd7/main.tf#LL4C1-L10C2
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

locals {
  ingress_ports = {
    for port in var.ingress_ports : "ingress_${port}" => {
      description = "Ingress to port ${port}"
      protocol    = "tcp"
      from_port   = port
      to_port     = port
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  cluster_ingress_ports = {
    for port in var.cluster_ingress_ports : "cluster_ingress_${port}" => {
      description                   = "Cluster API to port ${port}"
      protocol                      = "tcp"
      from_port                     = port
      to_port                       = port
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
  admin_users = [
    for user in var.admin_users : {
      username = user
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
      groups   = ["system:masters"]
    }
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_name                    = var.cluster_name
  cluster_version                 = var.k8s_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
  }

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_users = local.admin_users
  kms_key_administrators = concat(
    [data.aws_iam_session_context.current.issuer_arn],
    [for user in local.admin_users : user.userarn]
  )

  self_managed_node_groups = {
    workers = {
      name          = "${var.cluster_name}-workers"
      instance_type = var.instance_type
      min_size      = var.cluster_size
      max_size      = var.cluster_size
      instance_refresh = {
        strategy = "Rolling"
      }
      create_security_group = false
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = merge(local.ingress_ports, local.cluster_ingress_ports, {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  })

  depends_on = [module.vpc.public_subnets]

}
