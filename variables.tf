variable "project_name" {
  type = string
}
variable "vpc_module" {
  description = "Set of variables for the VPC Module"
}

variable "launch_template_module" {
  description = "Set of variables for the Launch Template Module"
}

variable "route53" {
  description  = "id zone route53"
}