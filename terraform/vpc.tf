resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
