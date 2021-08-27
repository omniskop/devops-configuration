
# Server running the app database
resource "aws_instance" "app_database" {
  tags = { Name = "App Database" }

  ami           = "ami-09e67e426f25ce0d7" # Ubuntu Focal
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  subnet_id     = aws_subnet.main_subnet.id

  vpc_security_group_ids = [
    aws_security_group.default-public-inbound.id,
    aws_security_group.default-vpc-inbound.id,
    aws_security_group.vpc-mongo-inbound.id,
    aws_security_group.allow-all-outbound.id
  ]
}

# Server running the app backend
resource "aws_instance" "app_server" {
  tags = { Name = "App Server" }

  count = var.server_count
  # ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux (yum package manager)
  ami           = "ami-09e67e426f25ce0d7" # Ubuntu Focal
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  subnet_id     = aws_subnet.main_subnet.id

  vpc_security_group_ids = [
    aws_security_group.default-public-inbound.id,
    aws_security_group.vpc-server-inbound.id,
    aws_security_group.default-vpc-inbound.id,
    aws_security_group.allow-all-outbound.id
  ]
}

# Client hosting
resource "aws_instance" "app_client" {
  tags = { Name = "App Client" }

  count         = var.client_count
  ami           = "ami-09e67e426f25ce0d7" # Ubuntu Focal
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  subnet_id     = aws_subnet.main_subnet.id

  vpc_security_group_ids = [
    aws_security_group.default-public-inbound.id,
    aws_security_group.default-vpc-inbound.id,
    aws_security_group.vpc-client-inbound.id,
    aws_security_group.allow-all-outbound.id
  ]
}

# Balancer of server
resource "aws_instance" "balancer_server" {
  tags = { Name = "Balancer Server" }

  ami           = "ami-09e67e426f25ce0d7" # Ubuntu Focal
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  subnet_id     = aws_subnet.main_subnet.id

  vpc_security_group_ids = [
    aws_security_group.default-public-inbound.id,
    aws_security_group.http-inbound.id,
    aws_security_group.allow-all-outbound.id
  ]
}
