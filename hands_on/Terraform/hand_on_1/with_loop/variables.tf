variable "private_subnet_info" {
  type  = list(object(
    {
        cidr = string
        az = string
    }
  ))
  
}