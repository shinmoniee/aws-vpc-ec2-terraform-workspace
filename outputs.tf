output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_id" {
    value = aws_subnet.publicsubnet.id
}

output "instance_id" {
    value = aws_instance.ec2instance.id
}

output "elatic_ip" {
    value = aws_eip.instance_eip.public_ip
}