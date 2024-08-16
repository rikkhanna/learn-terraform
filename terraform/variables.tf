variable "network_name" {
    type = string
    description = "VPC Network name"
    default = "vpc-network"
}

variable "auto_create_subnetworks" {
  type = bool
  description = "Enable or Disable the auto creation of subnets in a VPC."
  default = false
}

variable "subnet_name" {
  type = string
  description = "Name of subnet"
  default = "test-subnetwork"
}
variable "subnet_cidr_range" {
  type = string
  default = "10.10.0.0/24"
}
variable "region" {
  type = string
  default = "us-central1"
}

variable "sa_name" {
  type = string
  default = "gke-sa"
  description = "Name of the service account."
}
variable "sa_display_name" {
  type = string
  default = "GKE Service Account"
  description = "Display name of the service account."
}

variable "cluster_name" {
  type = string
  default = "my-gke-cluster"
}

variable "cluster_deletion_protection" {
  type = bool
  default = false
  description = "Enable or disable the deletion protection flag of cluster."
}
variable "remove_default_node_pool" {
  type = bool
  default = true
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "node_pool_name" {
   type = string
   default = "my-node-pool"
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}
variable "disk_size_gb" {
  type = number
  default = 10
}
variable "disk_type" {
  type = string
  default = "pd-standard"
}
variable "image_type" {
  type = string
  default = "COS_CONTAINERD"
}