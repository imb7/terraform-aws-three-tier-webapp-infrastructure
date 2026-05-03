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
        set -x

        #Set up logging FIRST — captures everything including the wait loop
        exec > >(tee /var/log/user-data.log) 2>&1

        echo "User data started at $(date)" > /tmp/user_data_status

        #Wait for internet — uses HTTPS (port 443 allowed in SG)
        until curl -sf --max-time 5 https://archive.ubuntu.com > /dev/null 2>&1; do
          echo "Waiting for internet connectivity... $(date)"
          sleep 5
        done

        echo "Network ready. Starting nginx installation at $(date)"

        apt-get update -y
        apt-get install -y nginx
        systemctl enable nginx
        systemctl start nginx

        #Use 'is-active' instead of 'status' — exits 0 on success, safe with set -e
        systemctl is-active --quiet nginx && echo "nginx is running" || echo "nginx failed to start"

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
          set -x
        
          #Logging first — captures everything including the wait loop
          exec > >(tee /var/log/user-data.log) 2>&1
        
          echo "User data started at $(date)" > /tmp/user_data_status
        
          #Wait for internet — HTTPS (port 443 allowed in app_sg)
          until curl -sf --max-time 5 https://archive.ubuntu.com > /dev/null 2>&1; do
            echo "Waiting for internet connectivity... $(date)"
            sleep 5
          done
        
          echo "Network ready. Starting Node.js installation at $(date)"
        
          apt-get update -y
        
          #Fetch setup script first, verify it downloaded, then execute
          curl -fsSL https://deb.nodesource.com/setup_lts.x -o /tmp/nodesource_setup.sh
          bash /tmp/nodesource_setup.sh
        
          apt-get install -y nodejs
        
          # Install pm2 globally
          npm install -g pm2
        
          #Verify node installed correctly — safe check, no set -e risk
          node --version && echo "Node.js installed: $(node --version)" || echo "Node.js install failed"
          npm --version  && echo "npm installed: $(npm --version)"      || echo "npm install failed"
        
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