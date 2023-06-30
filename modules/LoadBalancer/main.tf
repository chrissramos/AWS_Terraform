resource "aws_elb" "elb" {
  name = "elb"
  security_groups = [
    var.security_group
  ]
  subnets = [
    var.subnet[0], var.subnet[1] , var.subnet[2]
  ]
cross_zone_load_balancing   = true
health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

  depends_on = [var.subnet, var.security_group]

}