terraform  {

 backend "gcs" {
    bucket  = "terraform-state-bucket-rick"
    prefix = "nginx"
  }
}

provider "google" {
  project = "rish-dev"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# locals {
#   ansible_play = file("${path.module}/playbook.yml")
# }

resource "google_compute_instance" "nginx" {
  name         = "nginx-vm"
  machine_type = "e2-micro"

  tags = ["nginx"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      // Ephemeral public IP
    }
  }

#   metadata = {
#     enable-oslogin         = "True"
#     ansible_play             = local.ansible_play
#   }

#   metadata_startup_script = <<-EOT
#     #!/bin/bash
#     set -x
#     curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/ansible_play -H 'Metadata-Flavor: Google' > /tmp/ansible_play.yml
#   EOT

#   attached_disk {
#     device_name = "persistent-disk-1"
#     mode        = "READ_WRITE"
#     source      = google_compute_disk.data_disk.id
#   }

#   lifecycle {
#     ignore_changes = [
#       metadata_startup_script,
#       metadata["ssh-keys"],
#       metadata["enable-oslogin"],
#     ]
#   }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${self.network_interface[0].access_config[0].nat_ip},  playbook.yml"
  }
}