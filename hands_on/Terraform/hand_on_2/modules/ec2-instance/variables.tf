variable "instance_info" {
  type = list(object({
    name = string
    ami_id = string
    ec2_instance_type = string
    ssh_key_name = string
    security_groups = list(string)
    subnet_id = string
  }))
}

variable "default_tags" {
  type = map(string)
  default = {
        build = "Terraform module instance"
        author = "QSW"
    }
}

variable "project_tags" {
  type = map(string)
}