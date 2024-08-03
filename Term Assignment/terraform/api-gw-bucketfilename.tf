resource "aws_api_gateway_resource" "bucket" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  parent_id   = aws_api_gateway_rest_api.snap_vault.root_resource_id
  path_part   = "{bucket}"
}

# OPTIONS HTTP method.
resource "aws_api_gateway_method" "options_bucket" {
  rest_api_id      = aws_api_gateway_rest_api.snap_vault.id
  resource_id      = aws_api_gateway_resource.bucket.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
  depends_on = [ aws_api_gateway_resource.bucket ]
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "options_bucket" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.bucket.id
  http_method = aws_api_gateway_method.options_bucket.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [ aws_api_gateway_method.options_bucket ]
}

# OPTIONS integration.
resource "aws_api_gateway_integration" "options_bucket" {
  rest_api_id          = aws_api_gateway_rest_api.snap_vault.id
  resource_id          = aws_api_gateway_resource.bucket.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
  depends_on = [ aws_api_gateway_method.options_bucket ]
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "options_bucket" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.bucket.id
  http_method = aws_api_gateway_integration.options_bucket.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [ aws_api_gateway_integration.options_bucket ]
}









// OPTIONS {filename}

resource "aws_api_gateway_resource" "filename" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  parent_id   = aws_api_gateway_resource.bucket.id
  path_part   = "{filename}"
  depends_on = [ aws_api_gateway_resource.bucket ]
}

# OPTIONS HTTP method.
resource "aws_api_gateway_method" "options_filename" {
  rest_api_id      = aws_api_gateway_rest_api.snap_vault.id
  resource_id      = aws_api_gateway_resource.filename.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
  depends_on = [ aws_api_gateway_resource.filename ]
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "options_filename" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.filename.id
  http_method = aws_api_gateway_method.options_filename.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [ aws_api_gateway_method.options_filename ]
}

# OPTIONS integration.
resource "aws_api_gateway_integration" "options_filename" {
  rest_api_id          = aws_api_gateway_rest_api.snap_vault.id
  resource_id          = aws_api_gateway_resource.filename.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
  depends_on = [ aws_api_gateway_method.options_filename ]
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "options_filename" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.filename.id
  http_method = aws_api_gateway_integration.options_filename.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'PUT,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [ aws_api_gateway_integration.options_filename ]
}





// PUT {bucket}/{filename}

resource "aws_api_gateway_method" "put_filename" {
  http_method   = "PUT"
  rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
  resource_id   = aws_api_gateway_resource.filename.id
  authorization = "NONE"
  request_parameters = {
    "method.request.path.bucket"   = true,
    "method.request.path.filename" = true
  }
  depends_on = [ aws_api_gateway_resource.filename ]
}

resource "aws_api_gateway_method_response" "put_filename" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  resource_id = aws_api_gateway_resource.filename.id
  http_method = aws_api_gateway_method.put_filename.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [ aws_api_gateway_method.put_filename ]
}

resource "aws_api_gateway_integration" "put_filename" {
  rest_api_id             = aws_api_gateway_rest_api.snap_vault.id
  resource_id             = aws_api_gateway_resource.filename.id
  type                    = "AWS"
  http_method             = aws_api_gateway_method.put_filename.http_method
  integration_http_method = "PUT"
  uri                     = "arn:aws:apigateway:${var.region}:s3:path/{bucket}/{filename}"
  credentials             = "arn:aws:iam::862386165175:role/LabRole"

  request_parameters = {
    "integration.request.path.bucket"   = "method.request.path.bucket",
    "integration.request.path.filename" = "method.request.path.filename"
  }
  depends_on = [ aws_api_gateway_method.put_filename, aws_api_gateway_method_response.put_filename ]
}

resource "aws_api_gateway_integration_response" "put_filename" {
  rest_api_id  = aws_api_gateway_rest_api.snap_vault.id
  resource_id  = aws_api_gateway_resource.filename.id
  http_method  = aws_api_gateway_integration.put_filename.http_method
  status_code  = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [ aws_api_gateway_integration.put_filename ]
}
