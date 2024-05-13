//---- Lambdas ----//
data "archive_file" "lambda_turnon_turnoff_ec2_zip" {
  for_each    = var.lambda_code_turnon_turnoff_ec2
  type        = "zip"
  source_file = "${path.module}${each.value["source_file"]}"
  output_path = "${path.module}${each.value["output_path"]}"
}

resource "aws_lambda_function" "lambda_turnon_turnoff_ec2" {
  depends_on = [
    aws_iam_role.lambda_turnon_turnoff_ec2_role
  ]
  for_each         = var.lambda_turnon_turnoff_ec2
  function_name    = each.value.function_name
  description      = each.value["description"]
  role             = aws_iam_role.lambda_turnon_turnoff_ec2_role.arn
  filename         = each.value["filename"]
  source_code_hash = filebase64sha256("${each.value["filename"]}")
  handler          = each.value["handler"]
  runtime          = each.value["runtime"]
  timeout          = each.value["timeout"]
  memory_size      = each.value["memory_size"]
  architectures    = [each.value["architectures"]]
  tags = {
    Environment = var.tags["env"]
    project     = var.tags["project"]
  }
}

//---- Role ----//
resource "aws_iam_role" "lambda_turnon_turnoff_ec2_role" {
  name = "lambda-turnon-turnoff-ec2-role-${var.region}"
  assume_role_policy = templatefile("./iam/roles/lambda_turnon_turnoff_ec2.json", {
  })
}

//---- Custom Policies ----//
resource "aws_iam_policy" "lambda_start_stop_ec2_policy" {
  name = "access_start_stop_ec2_${var.region}"
  policy = templatefile("./iam/policies/lambda_turnon_turnoff_ec2.json", {
  })
}

//---- Attach Policies to Role ----//
resource "aws_iam_role_policy_attachment" "lambda_start_stop_policy_attach" {
  depends_on = [
    aws_iam_role.lambda_turnon_turnoff_ec2_role,
    aws_iam_policy.lambda_start_stop_ec2_policy
  ]
  role       = aws_iam_role.lambda_turnon_turnoff_ec2_role.name
  policy_arn = aws_iam_policy.lambda_start_stop_ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_execute_policy_attach" {
  role       = aws_iam_role.lambda_turnon_turnoff_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "lambda_service_policy_attach" {
  role       = aws_iam_role.lambda_turnon_turnoff_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

//---- Event Bridge ----//
resource "aws_scheduler_schedule" "lambda_turnon_turnoff_ec2" {
  depends_on = [
    aws_iam_role.lambda_turnon_turnoff_ec2_role,
    aws_iam_policy.eventbridge_scheduler_policy
  ]

  for_each = aws_lambda_function.lambda_turnon_turnoff_ec2

  name       = "lambda_turnon_turnoff_ec2_${each.value.function_name}"
  group_name = "default"

  # Set flexible_time_window to OFF to avoid conflicts
  flexible_time_window {
    mode = "OFF"
  }

  # Use cron expression for specific times
  schedule_expression = "cron(0 11,23 * * ? *)"

  target {
    arn      = each.value.arn
    role_arn = aws_iam_role.eventbridge_scheduler_role.arn
  }
}

//---- Role ----//
resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "lambda-turnon-turnoff-ec2-role-eventbridge-${var.region}"
  assume_role_policy = templatefile("./iam/roles/lambda_turnon_turnoff_eventbridge.json", {
  })
}

//---- Custom Policies ----//
resource "aws_iam_policy" "eventbridge_scheduler_policy" {
  name = "lambda-turnon-turnoff-ec2-policy-eventbridge-${var.region}"
  policy = templatefile("./iam/policies/lambda_turnon_turnoff_eventbridge.json", {
  })
}

//---- Attach Policies to Role ----//
resource "aws_iam_role_policy_attachment" "eventbridge_scheduler_policy_attach" {
  role       = aws_iam_role.eventbridge_scheduler_role.name
  policy_arn = aws_iam_policy.eventbridge_scheduler_policy.arn
}