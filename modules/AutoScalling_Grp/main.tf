resource "aws_autoscaling_group" "auto_sc_grp" {
  name                      = "${var.project_name}-asg"
  desired_capacity          = 3
  max_size                  = 5
  min_size                  = 3
  default_cooldown          = "60"
  health_check_grace_period = "600"
  health_check_type    = "ELB"
  load_balancers = [
    var.elb.id
  ]

  launch_template {
    id      = var.lc_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets

  provisioner "local-exec" {
    command = "sleep 120"  
  }

   depends_on = [var.lc_id]

}
