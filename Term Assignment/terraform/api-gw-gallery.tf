
resource "aws_api_gateway_resource" "gallery" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  parent_id   = aws_api_gateway_rest_api.snap_vault.root_resource_id
  path_part   = "gallery"
}

resource "aws_api_gateway_method" "post_gallery" {
  http_method   = "POST"
  rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
  resource_id   = aws_api_gateway_resource.gallery.id
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_gallery" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.gallery.id
  http_method = aws_api_gateway_method.post_gallery.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "post_gallery" {
  rest_api_id             = aws_api_gateway_rest_api.snap_vault.id
  resource_id             = aws_api_gateway_resource.gallery.id
  type                    = "AWS"
  http_method             = aws_api_gateway_method.post_gallery.http_method
  integration_http_method = "POST"
  uri                     = aws_lambda_function.gallery_functions.invoke_arn

  depends_on = [
    aws_api_gateway_method.post_gallery,
    aws_api_gateway_method_response.post_gallery,
  ]
}

resource "aws_api_gateway_integration_response" "post_gallery" {
    rest_api_id  = aws_api_gateway_rest_api.snap_vault.id
    resource_id  = aws_api_gateway_resource.gallery.id
    http_method  = aws_api_gateway_integration.post_gallery.http_method
    status_code  = "200"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
    depends_on = [aws_api_gateway_integration.post_gallery]
}

resource "aws_api_gateway_method" "options_gallery" {
  http_method   = "OPTIONS"
  rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
  resource_id   = aws_api_gateway_resource.gallery.id
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_gallery" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.gallery.id
  http_method = aws_api_gateway_method.options_gallery.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods"  = true,
    "method.response.header.Access-Control-Allow-Origin"   = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "options_gallery" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.gallery.id
  type        = "MOCK"
  http_method = aws_api_gateway_method.options_gallery.http_method
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [
    aws_api_gateway_method.options_gallery,
    aws_api_gateway_method_response.options_gallery,
  ]
}

resource "aws_api_gateway_integration_response" "options_gallery" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.gallery.id
  status_code = "200"
  http_method = aws_api_gateway_integration.options_gallery.http_method
  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
  depends_on = [ aws_api_gateway_integration.options_gallery ]
}