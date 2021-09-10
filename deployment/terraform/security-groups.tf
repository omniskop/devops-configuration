
resource "aws_security_group" "default-public-inbound" {
  tags = { Name = "Default Inbound" }

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
  tags = { Name = "HTTP Inbound" }

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
  tags = { Name = "VPC App-Server Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = var.server_port
    to_port     = var.server_port
  }
}

resource "aws_security_group" "vpc-client-inbound" {
  tags = { Name = "VPC App-Client Inbound" }

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

resource "aws_security_group" "vpc-metrics-inbound" {
  tags = { Name = "VPC Metrics Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow inbound connection to pm2-metrics from inside the vpc network
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 9209
    to_port     = 9209
  }

  ingress { # allow inbound connection to nginx prometheus exporter from inside the vpc network
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 9113
    to_port     = 9113
  }
}

resource "aws_security_group" "public-metrics-inbound" {
  tags = { Name = "Public Prometheus Inbound" }

  vpc_id = aws_vpc.main_vpc.id

  ingress { # allow inbound connection to the prometheus nginx proxy from outside
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 9091
    to_port     = 9091
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
