terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
  }
  backend "s3" {
    region  = "us-east-1"
    bucket  = "terraform-statesfiles-lucas"
    key     = "argocd/terraform.tfstate"
    profile = "select-dev"

  }
}

provider "aws" {
  region  = var.region
  profile = "select-dev"
}


data "aws_eks_cluster" "provider" {
  name = var.solidstack_vpc_module ? data.aws_ssm_parameter.cluster_name[0].value : var.cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = data.aws_eks_cluster.provider.id
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}
