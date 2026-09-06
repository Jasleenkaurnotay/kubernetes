# Query VPC ID of existing VPC
data "aws_vpc" "eks_vpc_id" {
    filter {
      name = "tag:ProjectName"
      values = [var.vpc_tag_value]
    }
}