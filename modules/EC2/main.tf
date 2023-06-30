resource "aws_launch_template" "my_lc" {
  name          = "${var.project_name}-lc-${terraform.workspace}"
  image_id      = var.ami
  instance_type = var.instance_size

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [aws_security_group.security_grp_launch.id]
  }


  depends_on = [var.efs_system]

  user_data = filebase64("${path.module}/init.sh")
}


###############################
########## Intance Profile ####
###############################

resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  statement {
      effect = "Allow"

      principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
      actions = ["sts:AssumeRole"]
  }
  
  
}

resource "aws_iam_role" "role" {
  name               = "${var.project_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

###############################
########## Security Group  ####
###############################

resource "aws_security_group" "security_grp_launch" {
  name        = "${var.project_name}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }
}
