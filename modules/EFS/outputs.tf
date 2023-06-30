output "efs_mount" {
    value = aws_efs_mount_target.efs_mount_target
}

output "efs_system" {
    value = aws_efs_file_system.efs_system
}