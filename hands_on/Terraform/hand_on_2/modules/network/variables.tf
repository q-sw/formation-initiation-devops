variable "vpc_name" {
  type = string
  description = "The VPC Name"
  default = "main"
}

variable "vpc_cidr" {
  type = string
  description = "The VPC CIDR"
  default = "10.0.0.0/16"
}

variable "public_subnet_info" {
  description = "List of public subnet informations"
  type = list(object({
    name = string
    cidr = string
    az = string
  }))
}

variable "private_subnet_info" {
  description = "List of private subnet informations"
  type = list(object({
    name = string
    cidr = string
    az = string
  }))
}

variable "default_tags" {
  type = map(string)
  default = {
        build = "Terraform modules Network"
        author = "QSW"
      }
  description = "The default module tags"
}

variable "project_tags" {
  type = map(string)
  description = "Map of project tag"
}