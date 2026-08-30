# Query existing VPC ID in AWS account
data "aws_vpc" "eks_vpc_id" {
    filter {
      name = "tag:ProjectName"
      values = [ var.vpc_tag_value ]
    }
}

# Query private subnets from the selected VPC ID above
data "aws_subnets" "priv_subs" {
    filter {
      name = "tag:Tier"
      values = [ var.pvt_sub_tag_value ]
    }
    filter {
      name = "vpc-id"
      values = [ data.aws_vpc.eks_vpc_id.id ]
    }
}

# Query default security group attached to EKS cluster
data "aws_security_group" "eks_default_sg" {
  filter {
    name = "tag:aws:eks:cluster-name"
    values = [ var.eks_cluster_name ]
  }
}

# Create custom sg to attach to RDS server
resource "aws_security_group" "rds_sg" {
  name = "${var.rds_name}-sg"
  vpc_id = data.aws_vpc.eks_vpc_id.id
}

# Create ingress egress security group rules to allow default EKS sg to reach DB
resource "aws_vpc_security_group_ingress_rule" "allow_from_eks" {
  security_group_id = aws_security_group.rds_sg.id
  from_port = 5432
  to_port = 5432
  referenced_security_group_id = data.aws_security_group.eks_default_sg.id
  ip_protocol = "tcp"  
}

# Egress rule is not required

# Generate random password for RDS server
resource "random_password" "rds_password" {
  length = 16
  lower = true
  min_lower = 4
  min_numeric = 2
  special = true
  override_special = "!#$%&*()-=+[]{}<>:?"
}

# Create RDS DB subnet group resource
resource "aws_db_subnet_group" "rds_db_sub_grp" {
  name = "${var.rds_name}-db-sub-grp"
  subnet_ids = data.aws_subnets.priv_subs.ids  
}

# Create RDS server
resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = var.rds_db_name
  engine = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  username = var.rds_username
  password = random_password.rds_password.result
  skip_final_snapshot = true
  backup_retention_period = 2
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  db_subnet_group_name = aws_db_subnet_group.rds_db_sub_grp.name
}

# Store RDS password in secrets manager
resource "aws_secretsmanager_secret" "rds_pass" {
  name = "${var.rds_name}"  
}

resource "aws_secretsmanager_secret_version" "rds_pass_value" {
  secret_id = aws_secretsmanager_secret.rds_pass.id
  secret_string = "postgresql://${var.rds_username}:${random_password.rds_password.result}@${aws_db_instance.rds.address}:5432/${aws_db_instance.rds.db_name}"
}