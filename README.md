# Homelab infrastructure

Homelab infrastructure deployed with terraform

## Folders

- [settings](settings): global settings used for the infrastructure.
- [ansible](ansible): playbooks used as tools. See their headers for info on what they do.
- [terraform](ansibterraformle): terraform modules.

## Use

1. Ensure terraform and SOPS are installed. SOPS secret must also be set.
2. `terraform init` to download required modules
3. get old `terraform.tfstate` or import objects
3. `terraform apply` to apply changes

## Notes

### Authentik

- token is created by going to `<authentik URL>/if/admin/#/core/tokens` .If it is done from the normal page then the tokens expire.