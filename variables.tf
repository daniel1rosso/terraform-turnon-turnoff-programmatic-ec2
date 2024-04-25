//---- Generic ----//
variable "region" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {
    env     = "Dev"
    project = "Terraform - Turn ON and TURN OFF"
  }
}

//---- Lambda ----//
variable "lambda_code_turnon_turnoff_ec2" {
  type = map(any)
}

variable "lambda_turnon_turnoff_ec2" {
  type = map(any)
}
