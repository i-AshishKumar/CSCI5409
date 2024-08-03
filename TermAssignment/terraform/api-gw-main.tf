resource "aws_api_gateway_rest_api" "snap_vault" {
  name               = "SnapVault"
  binary_media_types = ["image/jpeg", "image/png"]
}



resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.snap_vault.id
  

  depends_on = [
    aws_api_gateway_integration.get_user,
    aws_api_gateway_integration.options_user,
    aws_api_gateway_integration.post_gallery,
    aws_api_gateway_integration.options_gallery,
    aws_api_gateway_integration.put_filename,
    aws_api_gateway_integration.options_filename,
    aws_api_gateway_integration.options_bucket,
  ]
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.snap_vault.id
  deployment_id = aws_api_gateway_deployment.deploy.id
  depends_on    = [aws_api_gateway_deployment.deploy]
}
