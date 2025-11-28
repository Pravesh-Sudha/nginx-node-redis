output "eb_url" {
  value       = module.elastic-beanstalk-environment.endpoint  # Instance DNS for single-instance
  description = "Live app: "
}

output "environment_id" {
  value = module.elastic-beanstalk-environment.id
}