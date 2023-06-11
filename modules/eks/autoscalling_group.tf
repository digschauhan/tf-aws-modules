/*
resource "aws_autoscaling_group" "workers_asg" {
  name = "${var.cluster_name}-workers-${var.workers_instance_type}"

  max_size = var.workers_max
  min_size = var.workers_min

  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id = aws_launch_template.workers_lt.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-workers-${var.workers_instance_type}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "terraform"
    propagate_at_launch = true
  }
}


resource "aws_launch_template" "workers_lt" {
  name_prefix            = format("%s%s", "${var.cluster_name}-${var.workers_instance_type}", "-")
  instance_type          = var.workers_instance_type
  image_id               = var.workers_ami_id
  vpc_security_group_ids = [aws_security_group.workers_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.workers.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = var.workers_storage_size
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.common_tags
  }
}
*/