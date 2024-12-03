// VPC
resource "aws_vpc" "agent_zone" {
      cidr_block = "10.231.0.0/16" #Choose corresponding CIDR
      provider = aws.new_york

  tags = {
    Name = "AgentZone",
  }
  
}

// Subnet
resource "aws_subnet" "private-agent-zone" { 
  vpc_id            = aws_vpc.agent_zone.id
  cidr_block        = "10.231.1.0/24"
  availability_zone = "us-east-1a" #Change to your AZ
  provider = aws.new_york

  tags = {
    Name    = "private-agent-zone" 
    Service = "logs-collection"
    Owner   = "Chewbacca"
    Planet  = "Musafar"
  }
}
resource "aws_subnet" "public-agent-zone" { 
  vpc_id            = aws_vpc.agent_zone.id
  cidr_block        = "10.231.2.0/24"
  availability_zone = "us-east-1a" #Change to your AZ
  provider = aws.new_york
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-agent-zone" 
    Service = "logs-collection"
    Owner   = "Chewbacca"
    Planet  = "Musafar"
  }
}
resource "aws_eip" "agent_eip" {
  domain = "vpc"
  provider = aws.new_york

  tags = {
    Name = "nat-eip"
  }
}
// NAT
resource "aws_nat_gateway" "agent_nat" {
  allocation_id = aws_eip.agent_eip.id
  subnet_id     = aws_subnet.public-agent-zone.id
  provider = aws.new_york

  tags = {
    Name = "nat-gateway"
  }
}

// Route Table
resource "aws_route_table" "agent_private" {
  vpc_id = aws_vpc.agent_zone.id
  provider = aws.new_york

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.agent_nat.id
  }

  tags = {
    Name = "agent_private-route-table"
  }
}

resource "aws_route_table_association" "agent_private_rta" {
  subnet_id      = aws_subnet.private-agent-zone.id
  route_table_id = aws_route_table.agent_private.id
  provider = aws.new_york
}

resource "aws_internet_gateway" "agent_igw" {
  vpc_id = aws_vpc.agent_zone.id
  provider = aws.new_york

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "agent_public" {
  vpc_id = aws_vpc.agent_zone.id
  provider = aws.new_york

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.agent_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.public-agent-zone.id
  route_table_id = aws_route_table.agent_public.id
  provider = aws.new_york
}


// Instance
resource "aws_instance" "agent_instance" {
  ami                         = "ami-0453ec754f44f9a4a"
  instance_type               = "t2.micro"
  key_name                    = "Siem"
  subnet_id                   = aws_subnet.private-agent-zone.id
  vpc_security_group_ids      = [aws_security_group.agent_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.id
  provider = aws.new_york

    root_block_device {
    volume_size = 20  # Specify the size in GB
    volume_type = "gp3"  # General Purpose SSD
  }

user_data = filebase64(promtail.sh)

  tags = {
    Name = "Agent Instance",
  }
}

resource "aws_iam_role" "ssm_instance_role" {
  name = "SSMInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_instance_role.name
}

 

resource "aws_security_group" "agent_sg" {
    vpc_id = aws_vpc.agent_zone.id
    provider = aws.new_york

    ingress {
      from_port   = 9080    
      to_port     = 9080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     
    }


    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    
}

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}



