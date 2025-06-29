variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "trusted_cidr_blocks" {
  default = ["IP.ADDR.1/32"]
}

# IAM role
resource "aws_iam_role" "project-cluster" {
  name = "project-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM policy attachments
resource "aws_iam_role_policy_attachment" "project-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.project-cluster.name
}

resource "aws_iam_role_policy_attachment" "project-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.project-cluster.name
}

# Security group for EKS control plane
resource "aws_security_group" "project-cluster" {
  name        = "terraform-eks-project-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.cluster-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-project"
  }
}

# HTTPS rule
resource "aws_security_group_rule" "project-cluster-ingress-https" {
  cidr_blocks       = var.trusted_cidr_blocks
  description       = "Allow trusted IPs to communicate with the EKS API server over HTTPS"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.project-cluster.id
  to_port           = 443
  type              = "ingress"
}

# EKS cluster
resource "aws_eks_cluster" "project" {
  name     = var.cluster_name
  role_arn = aws_iam_role.project-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.project-cluster.id]
    subnet_ids         = aws_subnet.cluster-subnet[*].id
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.project-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.project-cluster-AmazonEKSVPCResourceController,
  ]
}
