
resource "aws_security_group" "eks_sg" {
  name        = "${var.cluster_name}-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    { "kubernetes.io/cluster/${var.cluster_name}" = "owned" },
  )

}

resource "aws_security_group" "workers_sg" {
  name        = "${var.cluster_name}-workers-sg"
  description = "Security group for all worker nodes in ${var.cluster_name}"

  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    { "Name" = "${var.cluster_name}-sg" },
    { "kubernetes.io/cluster/${var.cluster_name}" = "owned" },
  )
}

resource "aws_security_group_rule" "worker_to_worker_tcp" {
  description              = "Allow workers tcp communication with each other"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker_to_worker_udp" {
  description              = "Allow workers udp communication with each other"
  from_port                = 0
  protocol                 = "udp"
  security_group_id        = aws_security_group.workers_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_masters_ingress" {
  description              = "Allow workes kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers_sg.id
  source_security_group_id = aws_security_group.eks_sg.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_masters_https_ingress" {
  description              = "Allow workers kubelets and pods to receive https from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers_sg.id
  source_security_group_id = aws_security_group.eks_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "masters_api_ingress" {
  description              = "Allow cluster control plane to receive communication from workers kubelets and pods"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "masters_kubelet_egress" {
  description              = "Allow the cluster control plane to reach out workers kubelets and pods"
  from_port                = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  to_port                  = 10250
  type                     = "egress"
}

resource "aws_security_group_rule" "masters_kubelet_https_egress" {
  description              = "Allow the cluster control plane to reach out workers kubelets and pods https"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  to_port                  = 443
  type                     = "egress"
}

resource "aws_security_group_rule" "masters_workers_egress" {
  description              = "Allow the cluster control plane to reach out all worker node security group"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_sg.id
  source_security_group_id = aws_security_group.workers_sg.id
  type                     = "egress"
}