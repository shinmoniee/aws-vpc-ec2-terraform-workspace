variable "vpc_cidr" {
    type = string
    description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
    type = string
    description = "CIDR block for public subnet"
}

variable "key_name" {
    type = string
    description = "Existing key pair to use for EC2 instances"
}