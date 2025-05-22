variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  type        = string
  default     = "terraform-sensor"
}

variable "sns_topic_name" {
  type        = string
  default     = "terraform-sensor-notifications"
}