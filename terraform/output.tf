output "vpc_id" {
  value = aws_vpc.cloudlaunch.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "app_subnet_id" {
  value = aws_subnet.app.id
}

output "db_subnet_id" {
  value = aws_subnet.db.id
}

output "app_security_group_id" {
  value = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}

