resource "aws_vpc" "proj-vpc" {
    cidr_block = var.vpc-cidr

    tags = {
      Name = "myvpc"
    } 
}

resource "aws_subnet" "projsub1" {
    vpc_id = aws_vpc.proj-vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-east-2b"
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet-1"
    }
}

resource "aws_subnet" "projsub2" {
    vpc_id = aws_vpc.proj-vpc.id
    cidr_block = "10.0.20.0/24"
    availability_zone = "us-east-2c"
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet-2"
    }
}

resource "aws_internet_gateway" "proj-igw" {
    vpc_id = aws_vpc.proj-vpc.id 
}

resource "aws_route_table" "proj-route-table" {
    vpc_id = aws_vpc.proj-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.proj-igw.id
    }
}

resource "aws_route_table_association" "proj-RT-asso1" {
    route_table_id = aws_route_table.proj-route-table.id
    subnet_id = aws_subnet.projsub1.id
}

resource "aws_route_table_association" "proj-RT-asso2" {
    route_table_id = aws_route_table.proj-route-table.id
    subnet_id = aws_subnet.projsub2.id
}

resource "aws_security_group" "proj-sg" {
    name = "web"
    description = "To allow HTTP and SSH"
    vpc_id = aws_vpc.proj-vpc.id

    tags = {
      Name = "web-sg"
    }
}

resource "aws_security_group_rule" "proj-sg-rule1" {
    type = "ingress"
    description = "Open HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.proj-sg.id
}

resource "aws_security_group_rule" "proj-sg-rule2" {
    type = "ingress"
    description = "Open SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.proj-sg.id
}

resource "aws_security_group_rule" "proj-sg-egress" {
    type = "egress"
    description = "Allow all traffic"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.proj-sg.id
}

resource "aws_s3_bucket" "proj-bucket" {
    bucket = "devops-project-bucket-1-using-terraform"
}

resource "aws_s3_bucket_versioning" "proj-s3-version" {
    bucket = aws_s3_bucket.proj-bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_instance" "proj-webserver1" {
    ami = var.ec2-ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.proj-sg.id]
    subnet_id = aws_subnet.projsub1.id
    user_data = base64encode(file("userdata.sh")) 

    tags = {
      Name = "Web-server1"
    }
}

resource "aws_instance" "proj-webserver2" {
    ami = var.ec2-ami
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.proj-sg.id]
    subnet_id = aws_subnet.projsub2.id
    user_data = base64encode(file("userdata1.sh")) 

    tags = {
      Name = "Web-server2"
    }
}

resource "aws_lb" "proj-alb" {
    name = "web-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.proj-sg.id]
    subnets = [aws_subnet.projsub1.id, aws_subnet.projsub2.id]

    tags = {
      Name = "Web-ALB"
    }
}

resource "aws_lb_target_group" "proj-lb-tg" {
    name = "web-lb-tg"
    protocol = "HTTP"
    port = 80
    vpc_id = aws_vpc.proj-vpc.id

    health_check {
      path = "/"
      port = "traffic-port"
    } 
}

resource "aws_lb_target_group_attachment" "proj-lb-tg-attach1" {
    target_group_arn = aws_lb_target_group.proj-lb-tg.arn
    target_id = aws_instance.proj-webserver1.id
    port =80  
}

resource "aws_lb_target_group_attachment" "proj-lb-tg-attach2" {
    target_group_arn = aws_lb_target_group.proj-lb-tg.arn
    target_id = aws_instance.proj-webserver2.id
    port =80  
}

resource "aws_lb_listener" "proj-lb-listener" {
    load_balancer_arn = aws_lb.proj-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.proj-lb-tg.arn
      type = "forward"
    }
}

