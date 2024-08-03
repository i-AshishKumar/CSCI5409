resource "aws_lambda_function" "user_register_lambda" {
    function_name = "user_register"
    role = "arn:aws:iam::862386165175:role/LabRole"
    filename = "./resources/lambdas/user_register.zip"
    handler = "user_register.lambda_handler"
    runtime = "python3.12"
    memory_size = 512
    timeout = 15
    publish = true
    
}

resource "aws_lambda_function" "user_auth_lambda" {
    function_name = "user_authentication"
    role = "arn:aws:iam::862386165175:role/LabRole"
    filename = "./resources/lambdas/user_authentication.zip"
    handler = "user_authentication.lambda_handler"
    runtime = "python3.12"
    memory_size = 512
    timeout = 15
    publish = true
}

resource "aws_lambda_permission" "gateway_invoke" {
  statement_id = "AllowAPIGatewayInvoke"
  action      = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_auth_lambda.function_name
  principal    = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.snap_vault.execution_arn}/*/*/user"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lambda_function" "gallery_functions" {
    function_name = "user_gallery"
    role = "arn:aws:iam::862386165175:role/LabRole"
    filename = "./resources/lambdas/user_gallery.zip"
    handler = "user_gallery.lambda_handler"
    runtime = "python3.12"
    memory_size = 512
    timeout = 15
    publish = true
}

resource "aws_lambda_permission" "gallery_invoke" {
  statement_id = "AllowAPIGatewayInvoke"
  action      = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gallery_functions.function_name
  principal    = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.snap_vault.execution_arn}/*/POST/gallery"
  lifecycle {
    create_before_destroy = true
  }
}