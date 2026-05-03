resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}