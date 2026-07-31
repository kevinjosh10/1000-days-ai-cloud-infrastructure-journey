resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "web-lt"
  image_id      = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (us-east-1)
  instance_type = "t3.micro"
  
  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }
  
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ASG!</h1>" > /var/www/html/index.html
              EOF
  )
}

resource "aws_autoscaling_group" "this" {
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
