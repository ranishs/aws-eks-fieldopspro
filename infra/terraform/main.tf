
provider "aws" {
  region = var.region
}

# VPC with CIDR 10.10.0.0/26
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks-vpc"
  cidr = "10.10.0.0/26"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets = ["10.10.0.0/28", "10.10.0.16/28"]
  public_subnets  = ["10.10.0.32/28", "10.10.0.48/28"]
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "dotnet-eks"
  cluster_version = "1.29"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
}

# ECR Repository
resource "aws_ecr_repository" "dotnet_app" {
  name = "dotnet-app"
}