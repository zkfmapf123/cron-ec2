data "aws_caller_identity" "current" {}

################################################################################
### Event Bridge IAM
################################################################################
resource "aws_iam_role" "cron-event-bridge-iam" {
  name = "cron-event-bridge-iam"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "scheduler.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  tags = {
    Name     = "cron-event-bridge-iam"
    Resource = "iam"
    Target   = "event-bridge"
  }
}

resource "aws_iam_policy" "cron-event-bridge-policy" {
  name = "cron-event-bridge-iam"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          "${aws_lambda_function.function.arn}:*",
          "${aws_lambda_function.function.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attch-event-bridge" {
  role       = aws_iam_role.cron-event-bridge-iam.name
  policy_arn = aws_iam_policy.cron-event-bridge-policy.arn
}

################################################################################
### EC2 ON (terraform import aws_scheduler_schedule [group]/[resource_name])
################################################################################
resource "aws_scheduler_schedule" "ec2_on" {
  description                  = "ec2_on"
  name                         = "ec2_on"
  schedule_expression          = "cron(0 9 * * ? *)"
  schedule_expression_timezone = "Asia/Seoul"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.function.arn
    role_arn = aws_iam_role.cron-event-bridge-iam.arn

    retry_policy {
      maximum_retry_attempts = 0
    }
  }
}

################################################################################
### EC2 OFF
################################################################################
resource "aws_scheduler_schedule" "ec2_off" {
  description                  = "ec2_off"
  name                         = "ec2_off"
  schedule_expression          = "cron(0 18 * * ? *)"
  schedule_expression_timezone = "Asia/Seoul"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.function.arn
    role_arn = aws_iam_role.cron-event-bridge-iam.arn

    retry_policy {
      maximum_retry_attempts = 0
    }
  }
}
