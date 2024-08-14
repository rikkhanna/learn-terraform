terraform {

}

provider "google" {
  project = "rish-dev"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}