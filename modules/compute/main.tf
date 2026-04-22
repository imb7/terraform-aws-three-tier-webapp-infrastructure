#############################
# Web tier Launch Template  #
#############################

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ubuntu_ami_id
  instance_type = "t3.micro"

  # if you dont specify the block device mapping, it will use the default from the AMI which is 8GB.
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  key_name = var.key_pair_name

  iam_instance_profile {
    name = var.ec2_instance_profile
  }

  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx

              systemctl enable nginx
              systemctl start nginx
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-tier-instance"
      Tier = "web"
    }
  }
}


#############################
# App tier Launch Template  #
#############################

resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.ubuntu_ami_id
  instance_type = "t3.micro"

  # if you dont specify the block device mapping, it will use the default from the AMI which is 8GB.
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  key_name = var.key_pair_name

  iam_instance_profile {
    name = var.ec2_instance_profile
  }

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y

              # Install Node.js (LTS)
              curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
              apt install -y nodejs

              # Optional: process manager
              npm install -g pm2
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-tier-instance"
      Tier = "app"
    }
  }
}