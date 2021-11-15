# security group for EC2 instances
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "allow incoming HTTP traffic only"
  vpc_id      = aws_vpc.demo.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
# to disable if not needed (dont allow it in production)
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "app" {
  image_id        = var.ec2_amis
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.app_sg.id]

  #TODO REMOVE
  key_name    = aws_key_pair.generated_key.key_name
  name        = "app-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install software-properties-common wget git -y
              sudo add-apt-repository ppa:deadsnakes/ppa -y 
              sudo apt install python3.7 -y 
              sudo apt install python3-pip -y
              #install requirements
              sudo  pip install --no-cache-dir pytest==5.0.1  urllib3==1.25.3 requests==2.22.0  boto3 
              yum install -y java-1.8.0-openjdk-devel 
              git clone https://github.com/Abdessamii85/Helloworld-deploy-with-terraform.git
              cd Helloworld-deploy-with-terraform/server
              sed -i "s/MYINSTANCE/$aws_db_instance.rds.endpoint/g" database.py
              sed -i "s/MYPORT/$var.db_port/g" database.py
              sed -i "s/MYUSR/$var.rds_username/g" database.py
              sed -i "s/MYPASSWORD/$var.rds_password/g" database.py
             
   EOF


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  vpc_zone_identifier = [element(aws_subnet.private.*.id, 0)]

  load_balancers    = [aws_elb.app_elb.id]
  target_group_arns = ["${aws_alb_target_group.app-tg.arn}"]
  health_check_type = "ELB"

  min_size = 1
  max_size = 5

  tags = [{
    key                   = "Name"
    value                 = "app-asg"
    propagate_at_launch   = true
  }]
}
