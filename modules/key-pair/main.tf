resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file("~/.ssh/aws/terraform-three-tier-app.pub")
}