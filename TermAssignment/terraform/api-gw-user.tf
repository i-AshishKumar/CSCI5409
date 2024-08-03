resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  parent_id   = aws_api_gateway_rest_api.snap_vault.root_resource_id
  path_part   = "user"
}

resource "aws_api_gateway_method" "get_user" {
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
  resource_id   = aws_api_gateway_resource.user.id
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"   = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "get_user" {
  rest_api_id             = aws_api_gateway_rest_api.snap_vault.id
  resource_id             = aws_api_gateway_resource.user.id
  type                    = "AWS_PROXY"
  http_method             = aws_api_gateway_method.get_user.http_method
  integration_http_method = "POST"
  uri = aws_lambda_function.user_auth_lambda.invoke_arn

  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
  depends_on = [
    aws_api_gateway_method.get_user,
    aws_api_gateway_method_response.get_user,
    aws_lambda_permission.gateway_invoke
  ]
}

# resource "aws_api_gateway_integration_response" "get_user" {
#   rest_api_id = aws_api_gateway_rest_api.snap_vault.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = aws_api_gateway_integration.get_user.http_method
#   status_code = "200"
#   response_templates = {
#     "application/json" = ""
#   }
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }
#   depends_on = [ aws_api_gateway_integration.get_user ]
# }

# resource "aws_api_gateway_method" "options_user" {
#   http_method   = "OPTIONS"
#   rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
#   resource_id   = aws_api_gateway_resource.user.id
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method_response" "options_user" {
#   rest_api_id = aws_api_gateway_rest_api.snap_vault.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = aws_api_gateway_method.options_user.http_method
#   status_code = "200"
#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true,
#     "method.response.header.Access-Control-Allow-Methods"  = true,
#     "method.response.header.Access-Control-Allow-Origin"   = true
#   }
#   response_models = {
#     "application/json" = "Empty"
#   }
# }

# resource "aws_api_gateway_integration" "options_user" {
#   rest_api_id = aws_api_gateway_rest_api.snap_vault.id
#   resource_id = aws_api_gateway_resource.user.id
#   type        = "MOCK"
#   http_method = aws_api_gateway_method.options_user.http_method

#   depends_on = [
#     aws_api_gateway_method.options_user,
#     aws_api_gateway_method_response.options_user,
#   ]
# }

# resource "aws_api_gateway_integration_response" "options_user" {
#   rest_api_id = aws_api_gateway_rest_api.snap_vault.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = aws_api_gateway_integration.options_user.http_method
#   status_code = "200"
#   response_parameters = {
#         "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#         "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
#         "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     }
#     depends_on = [ aws_api_gateway_integration.options_user ]
# }

# OPTIONS HTTP method.
resource "aws_api_gateway_method" "options_user" {
  rest_api_id      = aws_api_gateway_rest_api.snap_vault.id
  resource_id      = aws_api_gateway_resource.user.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
  depends_on = [ aws_api_gateway_resource.user ]
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "options_user" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.options_user.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [ aws_api_gateway_method.options_user ]
}

# OPTIONS integration.
resource "aws_api_gateway_integration" "options_user" {
  rest_api_id          = aws_api_gateway_rest_api.snap_vault.id
  resource_id          = aws_api_gateway_resource.user.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
  depends_on = [ aws_api_gateway_method.options_user ]
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "options_user" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_integration.options_user.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [ aws_api_gateway_integration.options_user ]
}
