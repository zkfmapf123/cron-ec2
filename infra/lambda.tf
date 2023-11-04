#######################################################
### Lambda IAM
#######################################################
resource "aws_iam_role" "cron-lambda-iam" {
  name = "cron-ec2-lambda-iam"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name     = "cron-ec2-lambda-iam"
    Resource = "iam"
    Target   = "lambda"
  }
}

resource "aws_iam_policy" "ec2-onoff-policy" {
  name = "ec2-onoff-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attch" {
  role       = aws_iam_role.cron-lambda-iam.name
  policy_arn = aws_iam_policy.ec2-onoff-policy.arn
}


#######################################################
### Lambda
#######################################################
resource "null_resource" "function_binary" {

  ## 먼저 실행되도록..
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd init-lambda && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o hello hello.go"
  }
}

data "archive_file" "function_archive" {
  depends_on = [null_resource.function_binary]

  type        = "zip"
  source_file = "init-lambda/hello"
  output_path = "init-lambda/hello"
}

resource "aws_lambda_function" "function" {
  function_name = "ec2-handling-cron"
  role          = aws_iam_role.cron-lambda-iam.arn
  handler       = "hello"
  memory_size   = 128

  filename         = "init-lambda/hello"
  source_code_hash = data.archive_file.function_archive.output_base64sha256

  runtime = "go1.x"

  lifecycle {
    ignore_changes = ["environment", "filename", "source_code_hash"]
  }
}
