provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  //enable_vpn_gateway = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.32.0/24"
  availability_zone =  data.aws_availability_zones.avail.names[0]
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.33.0/24"
  availability_zone =  data.aws_availability_zones.avail.names[1]
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.my_vpc.id
  route     {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc_pub" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_assoc_pub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_pub.id
}