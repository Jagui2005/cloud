provider "aws" {
  region = var.aws_region 
}
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh" 
  ingress {
    from_port   = 22            
    to_port     = 22           
    protocol    = "tcp"         
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_instance" "awsvm1" {
  instance_type        = "t2.micro"              
  ami                  = "ami-0532be01f26a3de55" 
  iam_instance_profile = "LabInstanceProfile"    
  key_name             = "vockey"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "awsvm1"
  }
}

