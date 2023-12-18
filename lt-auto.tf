resource "aws_launch_template" "lunch-con" {
  name                    = "example-template"
  image_id                = "ami-02a2af70a66af6dfb"
  instance_type           = "t2.micro"
  key_name                = "prasad-devops"
  vpc_security_group_ids  = [aws_security_group.web_sg.id]
  user_data               = base64encode("#!/bin/bash\nyum install -y httpd\nsystemctl start httpd\necho 'Hello, World!' > /var/www/html/index.html\n")


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto-sca" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  launch_template {
    id      = aws_launch_template.lunch-con.id
    version = "$Latest"  # Use the latest version of the launch template
  }

  # Additional configurations for your Auto Scaling Group
  # ...
}
