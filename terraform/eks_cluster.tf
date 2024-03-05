resource "aws_eks_cluster" "prod_apps" {
  name     = var.cluster_name
  role_arn = data.aws_role.eks_prod_cluster.arn  #Needed
  version  = "1.28"

  vpc_config {
    subnet_ids              = data.aws_subnets.prod_apps_private.ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags = {
    Cluster                                = var.cluster_name
    Owner                                  = var.owner
    Env                                    = var.env
    Creator                                = var.creator
    Terraform                              = "true"
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  }
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_cloudwatch_log_group" "eks_prod_apps" {
  name              = "/aws/eks/prod_apps/cluster"
  retention_in_days = 90
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.prod_apps.name
  addon_name   = "aws-ebs-csi-driver"
}

resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.prod_apps.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.prod_apps.name
  addon_name   = "coredns"

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.prod_apps.name
  addon_name   = "kube-proxy"
}
