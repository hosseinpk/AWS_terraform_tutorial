variable "vpc_name" {
  default = "vpc_1"
  type = string
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
  type = string
}
variable "az_subnet1" {
  default = "10.10.1.0/24"
  type = string
}
variable "az_subnet2" {
  default = "10.10.2.0/24"
  type = string
}

variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "created_by" {
  type    = string
  default = "hossein"
}