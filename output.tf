output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.my_cluster.arn
}

output "node_group_name" {
  value = aws_eks_node_group.my_nodes.node_group_name
}

output "node_group_arn" {
  value = aws_eks_node_group.my_nodes.arn
}

output "node_group_instance_types" {
  value = aws_eks_node_group.my_nodes.instance_types
}
