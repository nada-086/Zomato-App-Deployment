resource "aws_launch_template" "bastion_server" {
  name_prefix            = "bastion_server"
  image_id               = "ami-0731becbf832f281e"
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.bastion_server_sg.id]


  tags = {
    Name = "Bastion Server"
  }
}

resource "aws_autoscaling_group" "bastion_server_as" {
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  target_group_arns = [aws_lb_target_group.bastion_tg.arn]

  launch_template {
    id      = aws_launch_template.bastion_server.id
    version = "$Latest"
  }
}

resource "aws_lb" "bastion_lb" {
  name               = "bastion-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bastion_lb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "Bastion Server Load Balancer"
  }
}

resource "aws_lb_target_group" "bastion_tg" {
  name     = "bastion-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.zomato_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Bastion Target Group"
  }
}

resource "aws_lb_listener" "bastion_listener" {
  load_balancer_arn = aws_lb.bastion_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bastion_tg.arn
  }
}
