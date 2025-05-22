output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}
