resource "aws_instance" "bastion_host" {
  ami           = var.ubuntu_ami_id
  instance_type = "t3.micro"

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  iam_instance_profile   = var.iam_instance_profile

  key_name = var.key_pair_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}