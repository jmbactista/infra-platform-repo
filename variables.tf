variable "cluster_name" {
  default     = "assessment-eks-cluster"
}

variable "eks_version" {
  default     = "1.25"
}

variable "region" {
  default     = "ap-southeast-1"
}

variable "nodegroup_name" {
  default     = "node-group"
}

variable "node_type" {
  default     = "t2.micro"
}

variable "nodes" {
  description = "EKS node count"
  default     = 2
}

variable "nodes_min" {
  description = "Min EKS nodes count"
  default     = 1
}

variable "nodes_max" {
  description = "Max EKS nodes count"
  default     = 2
}

variable "s3_bucket_name" {
  default     = "tf-backup-bucket"
}
