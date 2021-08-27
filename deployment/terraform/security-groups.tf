
resource "aws_security_group" "default-public-inbound" {
  tags = { Name = "Public Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow ssh from outside
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress { # allow all ipv4 icmp from outside
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
  }
}

resource "aws_security_group" "http-inbound" {
  tags = { Name = "Client Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
}

resource "aws_security_group" "vpc-server-inbound" {
  tags = { Name = "Public Server Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = var.server_port
    to_port     = var.server_port
  }
}

resource "aws_security_group" "default-vpc-inbound" {
  tags = { Name = "VPC Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow all ipv4 icmp from inside
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = -1
    to_port     = -1
  }
}

resource "aws_security_group" "vpc-client-inbound" {
  tags = { Name = "VPC Client Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow inbound connection to the client from inside the vpc network
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = var.client_port
    to_port     = var.client_port
  }
}

resource "aws_security_group" "vpc-mongo-inbound" {
  tags = { Name = "VPC Mongo Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow inbound connection to mongo from inside the vpc network
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 27017
    to_port     = 27017
  }
}

resource "aws_security_group" "allow-all-outbound" {
  tags = { Name = "Allow All Outbound" }

  vpc_id = aws_vpc.main_vpc.id

  egress {             # allow all outbound traffic
    protocol    = "-1" # all
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
