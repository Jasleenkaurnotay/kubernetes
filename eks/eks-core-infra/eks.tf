# EKS control plane:
# cluster name
# K8 version
# Auto mode off
# Endpoint access
# VPC & subnets
# Essential add ons - CNI, kube-proxy, core-dns etc
# Add on configuration

locals {
  node_config = {
    dev = {
      instance_types = ["t3.medium"]
      min_size = 1
      max_size = 2
      desired_size = 1
    }
    prod = {
      instance_types = ["t3.large"]
      min_size = 2
      max_size = 5
      desired_size = 3
    }
  }

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.24.0"

  name               = var.eks_cluster_name
  kubernetes_version = var.k8_version

  addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {
        before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true
  endpoint_public_access_cidrs = [ "106.192.122.160/32"]
  endpoint_private_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    "${var.eks_cluster_name}-ng" = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = local.node_config[var.environment].instance_types

      min_size     = local.node_config[var.environment].min_size
      max_size     = local.node_config[var.environment].max_size
      desired_size = local.node_config[var.environment].desired_size
    }
  }

}
