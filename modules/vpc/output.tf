output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "all_subnet_ids" {
  value = concat([for subnet in aws_subnet.private : subnet.id], [aws_subnet.public.id])
}
