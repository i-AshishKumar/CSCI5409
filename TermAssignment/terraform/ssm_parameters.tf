resource "aws_ssm_parameter" "api_gw_url" {
  name = "api-endpoint"
  type = "String"
  value = aws_api_gateway_deployment.deploy.invoke_url
}