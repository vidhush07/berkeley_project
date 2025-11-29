output "private_subnet_ids_by_az" {
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}