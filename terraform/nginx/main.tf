terraform {

  backend "gcs" {
    bucket = "terraform-state-bucket-rick"
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

locals {
  ssh_user = "ansible"
}

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


}

resource "local_file" "ansible-inventory" {
  depends_on = [google_compute_instance.nginx]
  content = templatefile("${path.cwd}/inventory.tpl",
    {
      public_ip = google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip
    }
  )
  filename = "${path.cwd}/inventory"
}

# Provisioner to run Ansible playbook
resource "null_resource" "ansible_provision" {
  # This depends on the VM creation and file rendering
  depends_on = [
    google_compute_instance.nginx,
    local_file.ansible-inventory
  ]

  provisioner "local-exec" {
    # command = "ansible-playbook -i inventory --private-key ansible-key playbook.yml"
    command = "ssh -i ansible-key -o StrictHostKeyChecking=no ansible@34.66.202.16 'echo SSH works'"
  }
}