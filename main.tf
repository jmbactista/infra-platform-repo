provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_az1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
}

resource "aws_subnet" "subnet_az2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.my_eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id
    ]
  }
}

resource "aws_eks_node_group" "my_nodes" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.my_node_role.arn
  subnet_ids      = [
    aws_subnet.subnet_az1.id,
    aws_subnet.subnet_az2.id
  ]
  instance_types  = [var.node_type]
  capacity_type   = "ON_DEMAND"

  scaling_config {
    min_size     = var.nodes_min
    max_size     = var.nodes_max
    desired_size = var.nodes
  }

  depends_on = [aws_eks_cluster.my_cluster]
}

resource "aws_iam_role" "my_eks_role" {
  name               = "my-eks-role"
  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Effect"    : "Allow",
        "Principal" : { "Service" : "eks.amazonaws.com" },
        "Action"    : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_eks_policy_attachment" {
  role       = aws_iam_role.my_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "my_node_role" {
  name               = "my-node-role"
  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Effect"    : "Allow",
        "Principal" : { "Service" : "ec2.amazonaws.com" },
        "Action"    : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-instance-profile"

  role = aws_iam_role.my_node_role.name
}
