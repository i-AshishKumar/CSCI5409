resource "aws_s3_bucket" "user_images" {
    bucket = "user-faces-cloud-term-2024"  
    force_destroy = true
}

resource "aws_s3_bucket" "visitor_images" {
    bucket = "visitor-faces-cloud-term-2024"  
    force_destroy = true
}

resource "aws_s3_bucket" "user_galleries" {
    bucket = "user-galleries-cloud-term-2024"  
    force_destroy = true
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_register_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.user_images.id}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.user_images.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.user_register_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
