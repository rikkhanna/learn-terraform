#!/bin/bash

DOCKER_IMAGE="us-central1-docker.pkg.dev/rish-dev/infrastructure/infra-init:latest"

# Authentication in GCP Docker Registry
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet

docker run --rm -it --pull=always \
  -v "$PWD/terragrunt:/init/terragrunt" \
  -v "$PWD/terraform:/init/terraform" \
  -v "$HOME/.config/gcloud:/root/.config/gcloud" \
  -v "$HOME/.ssh/:/root/.ssh" "${DOCKER_IMAGE}"