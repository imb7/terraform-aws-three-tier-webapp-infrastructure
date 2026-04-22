output "web_launch_template_id" {
  description = "ID of the web tier launch template"
  value       = aws_launch_template.web_lt.id
}

output "app_launch_template_id" {
  description = "ID of the app tier launch template"
  value       = aws_launch_template.app_lt.id
}