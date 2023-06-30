output "ec2_id" {
  value = aws_launch_template.my_lc.id
}

output "security_grp_launch" {
  value = aws_security_group.security_grp_launch.id
}

output "lauch_template" {
  value = aws_launch_template.my_lc
}
