//---- Generic ----//
region = "us-east-1"

//---- Lambda ----//
lambda_code_turnon_turnoff_ec2 = {
  turnon_turnoff_ec2 = {
    source_file = "/resources/lambda/instances_turnon_turnoff_ec2.py"
    output_path = "/resources/lambda/instances_turnon_turnoff_ec2.zip"
  }
}

lambda_turnon_turnoff_ec2 = {
  turnon_turnoff_ec2 = {
    function_name = "turnon_turnoff_ec2"
    description   = "turnon turnoff a ec2"
    filename      = "./resources/lambda/instances_turnon_turnoff_ec2.zip"
    handler       = "turnon_turnoff_ec2.lambda_handler"
    runtime       = "python3.10"
    timeout       = "900"
    memory_size   = "256"
    architectures = "x86_64"
  }
}
