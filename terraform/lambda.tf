# Create an S3 bucket with the desired ACL
resource "aws_s3_bucket" "my_bucket" {
  bucket = "thenovicesweb" # Use the existing "thenovicesweb" bucket
  acl    = "private"      # Set the ACL here (e.g., "private", "public-read", etc.)
}

# Create a Lambda function (your existing code for Lambda function)
resource "aws_lambda_function" "my_lambda" {
  filename      = "lambda_function.zip"
  function_name = "image-processing-lambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  timeout       = 10
  memory_size   = 128
}

# Configure S3 bucket notification to trigger Lambda (your existing code for notification)
resource "aws_lambda_permission" "s3_lambda_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"  # Optional: Filter by object prefix
  }
}

# IAM Role for Lambda Execution (your existing code for IAM role and policy)
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "IAM policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
          # Add any other permissions needed for your Lambda function
        ],
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_execution_attachment" {
  name       = "lambda_execution_attachment"
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  roles      = [aws_iam_role.lambda_execution_role.name]
}
