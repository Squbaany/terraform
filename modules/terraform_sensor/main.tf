resource "aws_lambda_function" "this" {
  function_name = var.function_name_prefix
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = var.lambda_role_arn

  filename         = var.source_code_path
  source_code_hash = var.source_code_hash

  environment {
    variables = var.environment_variables
  }

  timeout     = 30
  memory_size = 128
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
}
