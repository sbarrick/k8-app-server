data "aws_vpc" "prod_apps" {
  id = "vpc-123456"
}

data "aws_subnets" "prod_apps_private" {
    tags = {
        Name = "prod-apps-us-east-1*-private"
    }
}

data "aws_subnets" "prod_apps_public" {
    tags = {
        Name = "prod-apps-us-east-1*-public"
    }
}
