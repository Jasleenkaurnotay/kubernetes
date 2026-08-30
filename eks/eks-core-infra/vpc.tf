# Need to create the following VPC resources:
# VPC, 2 public subnets, 2 private subnets
# 1 NAT gateway
# Route tables - pub, pvt
# igw


# Query available azs in a given VPC
data "aws_availability_zones" "avail_azs" {
    state = "available"
}

# Referencing the official public AWS VPC module
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~> 6.6.1"    # Always lock version to one behind the latest release

    name = var.vpc_name
    cidr = var.vpc_cidr

    azs = [data.aws_availability_zones.avail_azs.names[0], data.aws_availability_zones.avail_azs.names[1]]
    private_subnets = var.pvt_sub_cidr
    public_subnets = var.pub_sub_cidr

    enable_nat_gateway = true # Want only on NAT gateway for bot private subnets
    single_nat_gateway = true

    public_subnet_tags = {
      "Tier" = "public"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
    }

    private_subnet_tags = {
      "Tier" = "private"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
    }
}