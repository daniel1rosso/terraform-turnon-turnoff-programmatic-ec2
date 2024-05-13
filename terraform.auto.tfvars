//---- Generic ----//
region = "us-east-1"

//---- Lambda ----//
lambda_code_turnon_turnoff_ec2 = {
  turnon_turnoff_ec2 = {
    source_file = "/code/lambda/instances_turnon_turnoff_ec2.py"
    output_path = "/code/lambda/zip/instances_turnon_turnoff_ec2.zip"
  }
}

lambda_turnon_turnoff_ec2 = {
  turnon_turnoff_ec2 = {
    function_name = "turnon_turnoff_ec2"
    description   = "turnon turnoff a ec2"
    filename      = "./code/lambda/zip/instances_turnon_turnoff_ec2.zip"
    handler       = "instances_turnon_turnoff_ec2.lambda_handler"
    runtime       = "python3.10"
    timeout       = "900"
    memory_size   = "128"
    architectures = "x86_64"
  }
}