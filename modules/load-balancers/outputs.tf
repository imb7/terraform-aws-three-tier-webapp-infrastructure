# updated outputs to reflect the new module version (asg v9.0), the target groups are now a list of objects instead of a list of strings
output "external_target_group_arns" {
  value = [for tg in module.external_alb.target_groups : tg.arn]
}

output "internal_target_group_arns" {
  value = [for tg in module.internal_alb.target_groups : tg.arn]
}