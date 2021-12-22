output "instance_ip_addr" {
    value = aws_instance.stevie-instance.public_ip
    description = "the public IP adress of the first instance"
}
output "instance_ip_addr2" {
    value = aws_instance.stevie-instance2.public_ip
    description = "the public IP adress of the second instance"
}
