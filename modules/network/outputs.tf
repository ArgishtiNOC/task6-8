output "vpc_id"{
    value = aws_vpc.task6-8.id
}

output "public_subnet_1_id"{
    value = aws_subnet.task-public-1.id
}

output "public_subnet_2_id"{
    value = aws_subnet.task-public-2.id
}

output "private_subnet_1_id"{
    value = aws_subnet.task-private-1.id
}

output "private_subnet_2_id"{
    value = aws_subnet.task-private-2.id
}

