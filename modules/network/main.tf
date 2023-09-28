resource "aws_vpc" "task6-8" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "task-public-1"{
    vpc_id = aws_vpc.task6-8.id
    cidr_block = var.public_subnet_1
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name                        = "public-1"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1 
    }
}

resource "aws_subnet" "task-public-2"{
    vpc_id = aws_vpc.task6-8.id
    cidr_block = var.public_subnet_2
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name                        = "public-2"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1 
    }
}

resource "aws_subnet" "task-private-1"{
    vpc_id = aws_vpc.task6-8.id
    cidr_block = var.private_subnet_1
    availability_zone = "us-east-1a"
    tags = {
      Name                              = "private-1"
      "kubernetes.io/cluster/eks"       = "shared"
      "kubernetes.io/role/internal-elb" = 1 
    }
}

resource "aws_subnet" "task-private-2"{
    vpc_id = aws_vpc.task6-8.id
    cidr_block = var.private_subnet_2
    availability_zone = "us-east-1b"
    tags = {
      Name                               = "private-2"
      "kubernetes.io/cluster/eks"        = "shared"
      "kubernetes.io/role/internal-elb"  = 1 
    }
}

resource "aws_route_table" "route-table-task"{
    vpc_id = aws_vpc.task6-8.id

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id=aws_internet_gateway.task-igw.id
    }
}

resource "aws_internet_gateway" "task-igw"{
    vpc_id = aws_vpc.task6-8.id 
    tags = {
      Name= "task6-8"
    }
}
 
resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.task-igw]
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.task-igw]
}

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id = aws_subnet.task-public-1.id
  tags = {
    Name = "NAT1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id = aws_subnet.task-public-2.id
  tags = {
    Name = "NAT1"
  }
}

resource "aws_route_table_association" "public1_subnet_association" {
  subnet_id      = aws_subnet.task-public-1.id
  route_table_id = aws_route_table.route-table-task.id
}

resource "aws_route_table_association" "public2_subnet_association" {
  subnet_id      = aws_subnet.task-public-2.id
  route_table_id = aws_route_table.route-table-task.id
}



resource "aws_route_table" "private-1"{
    vpc_id = aws_vpc.task6-8.id

    route {
        cidr_block= "0.0.0.0/0"
        nat_gateway_id=aws_nat_gateway.gw1.id
    }
}

resource "aws_route_table" "private-2"{
    vpc_id = aws_vpc.task6-8.id

    route {
        cidr_block= "0.0.0.0/0"
        nat_gateway_id=aws_nat_gateway.gw2.id
    }
}

resource "aws_route_table_association" "private1_subnet_association" {
  subnet_id      = aws_subnet.task-private-1.id
  route_table_id = aws_route_table.private-1.id
}


resource "aws_route_table_association" "private2_subnet_association" {
  subnet_id      = aws_subnet.task-private-2.id
  route_table_id = aws_route_table.private-2.id
}