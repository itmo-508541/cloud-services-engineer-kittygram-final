variable "zone" {
  type        = string
  description = "Zone"
}

variable "network_name" {
  type      = string
  sensitive = true
}

variable "subnet_name" {
  type      = string
  sensitive = true
}

variable "sg_name" {
  type      = string
  sensitive = true
}
