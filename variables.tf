variable "aws_access_key_id" {
    type = string
}

variable "aws_secret_access_key" {
    type = string
}

variable "map_users" {
    description = "Additional IAM users to add to the aws-auth configmap"
    type = list(object({
        userarn  = string
        username = string
        groups   = list(string)
    }))
}

# Variables with defaults below
variable "region" {
    type = string
    default = "eu-north-1"
}

variable "vpc_cidr" {
    type = string
    default = "172.72.0.0/16"
}

variable "cluster_name" {
    type = string
    default = "simple-k8s-cluster"
}

variable "k8s_version" {
    type = string
    default = "1.20"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "cluster_size" {
    type = number
    default = 5
}
