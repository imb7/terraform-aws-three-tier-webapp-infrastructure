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
              set -e
              set -x

              while ! ping -c1 8.8.8.8 &>/dev/null; do
              echo "Waiting for network..."
              sleep 3
              done
              
              # Log all output
              exec > >(tee /var/log/user-data.log)
              exec 2>&1
              
              echo "Starting nginx installation at $(date)"
              echo "User data started" > /tmp/user_data_status
              
              # Update package manager
              apt-get update -y
              
              # Install nginx
              apt-get install -y nginx
              
              # Enable and start nginx
              systemctl enable nginx
              systemctl start nginx
              
              # Verify nginx is running
              systemctl status nginx
              
              echo "Nginx installation completed successfully at $(date)"
              echo "User data finished" >> /tmp/user_data_status
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
              set -e
              set -x

              while ! ping -c1 8.8.8.8 &>/dev/null; do
              echo "Waiting for network..."
              sleep 3
              done
              
              # Log all output
              exec > >(tee /var/log/user-data.log)
              exec 2>&1
              
              echo "Starting Node.js installation at $(date)"
              echo "User data started" > /tmp/user_data_status
              
              # Update package manager
              apt-get update -y
              
              # Install Node.js (LTS)
              curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
              apt-get install -y nodejs
              
              # Optional: process manager
              npm install -g pm2
              
              echo "Node.js installation completed successfully at $(date)"
              echo "User data finished" >> /tmp/user_data_status
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