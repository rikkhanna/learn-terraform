variable "network_name" {
  type        = string
  description = "VPC Network name"
  default     = "vpc-network"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "Enable or Disable the auto creation of subnets in a VPC."
  default     = false
}

variable "subnet_name" {
  type        = string
  description = "Name of subnet"
  default     = "test-subnetwork"
}
variable "subnet_cidr_range" {
  type    = string
  default = "10.10.0.0/24"
}
variable "region" {
  type    = string
  default = "us-central1"
}

variable "ansible_key" {
  default = null
}