provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = merge(
        local.common_tags,
        {
            Name = "${terraform.workspace}-vpc"
        }
    )
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        local.common_tags,
        {
            Name = "${terraform.workspace}-igw"
        }
    )
}

resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr

    tags = merge(
        local.common_tags,
        {
            Name = "${terraform.workspace}-public-subnet"
        }
    )
}

resource "aws_route_table" "publicrt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = merge(
        local.common_tags,
        {
            Name = "${terraform.workspace}-public-rt"
        }
    )
}

resource "aws_route_table_association" "rta" {
    subnet_id      = aws_subnet.publicsubnet.id
    route_table_id = aws_route_table.publicrt.id
}

resource "aws_instance" "ec2instance" {
    ami = "ami-0427090fd1714168b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.publicsubnet.id
    key_name = var.key_name

    tags = merge(
        local.common_tags,
        {
            Name = "${terraform.workspace}-instance"
        }
    )
}

resource "aws_eip" "instance_eip" {
    domain = "vpc"
    instance = aws_instance.ec2instance.id
    depends_on = [ aws_internet_gateway.igw ]

    tags = merge(
        local.common_tags,
        {
            Name ="${terraform.workspace}-eip"
        }
    )
}