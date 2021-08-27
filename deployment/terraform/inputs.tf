
variable "public_key" {
  type = string
}

variable "username" {
  type = string
  default = "ubuntu"
}

variable "nodejs_version" {
  type = string
}

variable "public_url" {
  type = string
}

variable "api_url" {
  type = string
}

variable "database_port" {
  type = number
}

variable "server_port" {
  type = number
}

variable "client_port" {
  type = number
}
