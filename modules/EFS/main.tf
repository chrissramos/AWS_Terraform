resource "aws_efs_file_system" "efs_system" {
  creation_token = "randall-efs-token"
  tags = {
    Name = "randall-efs"
  }

  depends_on = [var.subnet]
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs_system.id
  subnet_id       = var.subnet[0]
  security_groups = [var.security_group]
}
