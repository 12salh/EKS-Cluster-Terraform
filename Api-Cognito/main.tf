# ------------------------
# Cognito
# ------------------------
resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-user-pool-${var.environment}"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret = false

  callback_urls = ["https://example.com"]
  logout_urls   = ["https://example.com"]

  allowed_oauth_flows       = ["implicit"]
  allowed_oauth_scopes      = ["openid", "email"]
  allowed_oauth_flows_user_pool_client = true
}


resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.project_name}-${var.environment}-auth"
  user_pool_id = aws_cognito_user_pool.main.id
}

# ------------------------
# API Gateway
# ------------------------
resource "aws_apigatewayv2_api" "this" {
  name                     = "${var.project_name}-api-gateway-${var.environment}"
  protocol_type            = "HTTP"
  route_selection_expression = "$request.method $request.path"
}

# ------------------------
# VPC Link to NLB
# ------------------------
resource "aws_apigatewayv2_vpc_link" "this" {
  name       = "${var.project_name}-vpc-link"
  subnet_ids = var.subnet_ids
  security_group_ids = []
}

# ------------------------
# Integration with NLB
# ------------------------
data "aws_lb" "nlb" {
  name = "add2174c8c0364b1cb33032a96757037"  # مثلا k8s-ingressn-nginxing-xxxx
}

data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.nlb.arn
  port              = 80
}

resource "aws_apigatewayv2_integration" "nlb" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = data.aws_lb_listener.http.arn  # <--- هنا ARN مش DNS
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  payload_format_version = "1.0"
}
# ------------------------
# Cognito Authorizer
# ------------------------
resource "aws_apigatewayv2_authorizer" "cognito" {
  name             = "cognito-authorizer"
  api_id           = aws_apigatewayv2_api.this.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
    audience = [aws_cognito_user_pool_client.client.id]
  }
}

# ------------------------
# Route protected by Cognito
# ------------------------
resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"

  target             = "integrations/${aws_apigatewayv2_integration.nlb.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}

# ------------------------
# Stage
# ------------------------
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

# resource "aws_cognito_user" "test" {
#   username     = "engsaleh862@gmail.com"
#   user_pool_id = aws_cognito_user_pool.main.id
#   temporary_password = "TempPass123!"
# }

resource "aws_cognito_user" "test" {
  username         = "engsaleh862@gmail.com"
  user_pool_id     = aws_cognito_user_pool.main.id
  temporary_password = "TempPass123!"

  lifecycle {
    prevent_destroy = true
  }
}