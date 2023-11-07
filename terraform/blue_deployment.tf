# Create a blue Auto Scaling Group
resource "aws_autoscaling_group" "blue" {
  name               = "blue_asg"
  max_size           = 2
  min_size           = 1
  health_check_type  = "ELB"
  desired_capacity   = 1
  target_group_arns  = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier = [aws_subnet.public-1.id, aws_subnet.public-2.id]

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.blue.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"    # add one instance
  cooldown               = "180"  # cooldown period after scaling
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.blue.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.blue.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "180"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.blue.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}
#  Load balancer Listener Rule
resource "aws_lb_listener_rule" "blue_rule" {
  listener_arn = aws_lb_listener.my_lb_listener.arn
  priority      = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
  condition {
      host_header {
      values = ["blue.thenovices.net"]
    }
  }
}