data "aws_ssm_parameter" "eks_ami_id" {
  name = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_cluster" "eks" {
  name    = var.cluster_name
  version = var.kubernetes_version

  vpc_config {
    security_group_ids = [aws_security_group.eks_sg.id]
    subnet_ids         = concat(var.private_subnet_ids, var.public_subnet_ids)
  }

  role_arn = aws_iam_role.eks_cluster_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_role_policy_attachment,
  ]

}

# Worker node group
resource "aws_eks_node_group" "workers_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${aws_eks_cluster.eks.name}-node-group"
  node_role_arn   = aws_iam_role.workers_role.arn
  subnet_ids      = var.private_subnet_ids

  version         = var.kubernetes_version
  release_version = var.workers_ami_id == "" ? data.aws_ssm_parameter.eks_ami_id.value : var.workers_ami_id

  scaling_config {
    desired_size = var.workers_desired
    max_size     = var.workers_max
    min_size     = var.workers_min
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy,
  ]
}