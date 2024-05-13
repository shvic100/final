resource "aws_launch_configuration" "app" {
  name          = "app-launch-configuration"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  min_size             = 1
  max_size             = 10
  vpc_zone_identifier  = ["subnet-123456"]

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}
