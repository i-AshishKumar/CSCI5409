resource "aws_cloudwatch_log_group" "user_auth_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.user_auth_lambda.function_name}"
  skip_destroy = false
  depends_on = [ aws_lambda_function.user_auth_lambda ]
}
resource "aws_cloudwatch_log_group" "user_register_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.user_register_lambda.function_name}"
  skip_destroy = false
  depends_on = [ aws_lambda_function.user_register_lambda ]
}
resource "aws_cloudwatch_log_group" "gallery_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.gallery_functions.function_name}"
  skip_destroy = false
  depends_on = [ aws_lambda_function.gallery_functions ]

}