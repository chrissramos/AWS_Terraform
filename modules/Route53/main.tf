resource "aws_route53_record" "route53-Randall" {
  zone_id = var.route53
  name    = "randall"
  type    = "CNAME"
  ttl     = 60

  records  = [var.lb.dns_name]
  depends_on = [var.lb]
}