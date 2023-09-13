

provider "aws" {
  region = "ap-south-1" # Specify your AWS region
}

resource "aws_iam_role" "lambda_role" {
  name = "tmdb_api_lambda_role" # Specify the name for your IAM role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com" # Example principal (can be changed as needed)
        }
      }
    ]
  })
}
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir = "${path.module}/../python" # Specify the path to your Python script
  output_path = "${path.module}/../python/deploymentpck.zip" # Specify the output ZIP file name
}
resource "aws_lambda_function" "tmdb_lambda_function" {
  filename = "${path.module}/../python/deploymentpck.zip"
  function_name = "my_tmdb_api_lambda_function"
  description = "Lambda function for ingestion of tmdb api"
  role = aws_iam_role.lambda_role.arn
  handler = "helloworld.lambda_handler"
  runtime = "python3.9"
}

