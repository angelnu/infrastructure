# Homelab infrastructure

Homelab infrastructure deployed with terraform

## Folders

- [documentation](docs): Documentation for the infrastructure
- [settings](settings): global settings used for the infrastructure.
- [ansible](ansible): playbooks used as tools. See their headers for info on what they do.
- [terraform](terraform): terraform modules.

## Usage

1. Ensure terraform and SOPS are installed. SOPS secret must also be set.
2. `terraform init` to download required modules
3. get old `terraform.tfstate` or import objects
3. `terraform apply` to apply changes

