output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

output "user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_domain" {
  value = aws_cognito_user_pool_domain.main.domain
}

output "vpc_link_id" {
  value = aws_apigatewayv2_vpc_link.this.id
}
