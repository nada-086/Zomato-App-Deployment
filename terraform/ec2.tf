resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.bastion_server_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Bastion Server"
  }
}

resource "aws_launch_template" "node" {
  name_prefix            = "node"
  image_id               = var.ami
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.node_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "Node"
  }
}

resource "aws_autoscaling_group" "node_as" {
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.node.id
    version = "$Latest"
  }
}