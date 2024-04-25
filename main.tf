//---- LAMBDAS ----//
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
  function_name    = each.value["function_name"]
  description      = each.value["description"]
  role             = aws_iam_role.lambda_turnon_turnoff_ec2_role.arn
  filename         = each.value["filename"]
  source_code_hash = filebase64sha256("${each.value["filename"]}")
  handler          = each.value["handler"]
  runtime          = each.value["runtime"]
  timeout          = each.value["timeout"]
  memory_size      = each.value["memory_size"]
  architectures    = [each.value["architectures"]]
}

//---- Role ----//

resource "aws_iam_role" "lambda_turnon_turnoff_ec2_role" {
  name               = "lambda-turnon-turnoff-ec2-role-${var.region}"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"                 
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

//---- Custom Policies ----//

resource "aws_iam_policy" "lambda_start_stop_ec2_policy" {
  name = "access_start_stop_ec2_${var.region}"
  policy = templatefile("./resources/policy/lambda-stop-start-ec2.json", {
  })
}

//---- Attach Policies to Role ----//

resource "aws_iam_role_policy_attachment" "lambda_campaigns_policy_attach5" {
  role       = aws_iam_role.lambda_turnon_turnoff_ec2_role.name
  policy_arn = aws_iam_policy.lambda_start_stop_ec2_policy.arn
}

//---- Event Bridge ----//

resource "aws_cloudwatch_event_rule" "eventbridge_lambda_start_stop_ec2" {
  name                = "eventbridge_lambda_start_stop_ec2_${var.region}"
  schedule_expression = "cron(0 8,20 * * ? *)"
}

resource "aws_cloudwatch_event_target" "eventbridge_lambda_start_stop_ec2_target" {
  depends_on = [
    aws_lambda_function.lambda_turnon_turnoff_ec2
  ]
  for_each = aws_lambda_function.lambda_turnon_turnoff_ec2
  rule     = aws_cloudwatch_event_rule.eventbridge_lambda_start_stop_ec2.name
  target_id = "eventbridge_lambda_start_stop_ec2_target_${each.key}"
  arn       = each.value.arn
}