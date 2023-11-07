# Create a Route53 hosted zone for your DNS website domain name
resource "aws_route53_zone" "thenovices" {
  name = "thenovices.net"
}

# Create an A record that maps the domain name to your load balancer
resource "aws_route53_record" "thenovices" {
  zone_id = aws_route53_zone.thenovices.zone_id
  name = "thenovices.net"
  type = "A"
  alias {
    name = aws_lb.my_alb.dns_name
    zone_id = aws_lb.my_alb.zone_id
    evaluate_target_health = true
  }
}