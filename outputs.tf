output "lambda_function_arn" {
  value       = module.terraform_lambda.lambda_function_arn 
}

output "lambda_function_name" {
  value       = module.terraform_lambda.lambda_function_name 
}

output "sns_topic_arn" {
  value       = aws_sns_topic.notifications.arn
}
