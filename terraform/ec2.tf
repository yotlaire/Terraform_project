# Launch Template
resource "aws_launch_template" "my_launch_template" {
  name = "my_launch_template"

  image_id      = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.my_sg.id]
  }

  user_data = filebase64("${path.module}/web.sh")
}
#  IAM Instance Profile
resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-instance-profile"
}