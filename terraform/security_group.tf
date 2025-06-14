resource "aws_security_group" "bastion_server_sg" {
  name        = "bastion-server-sg"
  description = "Allow HTTP, SSH, 8080/tcp, 9000/tcp and 8081/tcp inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.zomato_vpc.id

  tags = {
    Name = "Bastion Server SG"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    description = "Jenkins Port"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 9000
    to_port     = 9000
    description = "SonarQube Port"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    description = "Nexus Port"
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


resource "aws_security_group" "node_sg" {
  name        = "node-sg"
  description = "Allow all inbound traffic from the bastion-sg and allow all the outbound traffic"
  vpc_id      = aws_vpc.zomato_vpc.id

  tags = {
    Name = "Node SG"
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.bastion_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}