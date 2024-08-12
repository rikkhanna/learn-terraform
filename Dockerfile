FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y wget unzip git && \
    wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip && \
    unzip terraform_1.7.0_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_1.7.0_linux_amd64.zip && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.50.0/terragrunt_linux_amd64 -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

WORKDIR /init

ENTRYPOINT ["bash"]
