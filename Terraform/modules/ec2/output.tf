output "private_ec2_ip" {
  value = aws_instance.ec2.private_ip
}

output "eic_endpoint_id" {
  value = aws_ec2_instance_connect_endpoint.eic.id
}