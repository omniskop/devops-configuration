
// We create a vpc with our own subnet that allows our instances to communicate
// with each other without necessarily exposing them to the internet.

resource "aws_vpc" "main_vpc" {
  tags = { Name = "main vpc" }

  cidr_block = "10.0.0.0/16" // subnet mask
}

resource "aws_subnet" "main_subnet" {
  tags = { Name = "main subnet" }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/16"
  map_public_ip_on_launch = "true"
}

// The gateway allows internet access from and to our vpc
resource "aws_internet_gateway" "main_gateway" {
  tags = { Name = "main gateway" }

  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_default_route_table" "route_table" {
  tags = { Name = "default route table" }

  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}
