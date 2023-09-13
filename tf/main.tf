provider "aws" {
   region ="ap-south-1"
}



resource "aws_iam_role" "lambda_role" {
  name = "tmdb_api_lambda_role"
   assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


data "archive_file" "python_script_zip" {
  type        = "zip"
  source_dir = data.template_file.python_script_rendered.filename
  output_path = "${path.module}/helloworld.zip"
}
resource "aws_lambda_function" "tmdb_lambda_function" {
  filename = "${path.module}/../python/helloworld.zip"
  function_name = "my_tmdb_api_lambda_function"
  description = "Lambda function for ingestion of tmdb api"
  role = aws_iam_role.lambda_role.arn
  handler = "helloworld.lambda_handler"
  runtime = "python3.9"
}

