provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_role" "lab_role" {
  name = "LabRole" 
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "lambda/" 
  output_path = "${path.module}/lambda_function.zip"
}

data "aws_ssm_parameter" "student_email" {
  name = "student-email" 
}

resource "aws_sns_topic" "notifications" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "email"
  endpoint  = data.aws_ssm_parameter.student_email.value
}

module"terraform_lambda" {
  source = "./modules/terraform_sensor"

  function_name_prefix = var.lambda_function_name 
  lambda_role_arn      = data.aws_iam_role.lab_role.arn
  source_code_path     = data.archive_file.lambda_zip.output_path
  source_code_hash     = data.archive_file.lambda_zip.output_base64sha256
  
  environment_variables = {
    SNS_TOPIC_ARN = aws_sns_topic.notifications.arn 
  }
}