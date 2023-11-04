############################################################
### EC2 Security Group
############################################################
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "instance_sg"
  vpc_id      = var.vpc_id

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

  tags = {
    Name     = "instance_sg"
    Resource = "sg"
  }
}

############################################################
### aws key pair
############################################################
resource "aws_key_pair" "key_pair" {
  key_name   = "cron-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

############################################################
### EC2
############################################################
resource "aws_instance" "instance" {

  count = 3

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name = "cron-ec2-example-${count.index}"
    Properties = "onoff-instance"
  }
}
