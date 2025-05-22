variable "function_name_prefix" {
  type        = string
}

variable "lambda_role_arn" {
  type        = string
}

variable "source_code_path" {
  type        = string
}

variable "source_code_hash" {
  type        = string
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
}
