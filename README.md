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

## Usefull commands

### Use locally built providers

1. Edit $HOME/.terraformrc
2. Add dev_overrides there to create dev aliases for used providers to point to the local build folder:
   ```
    provider_installation {
    dev_overrides {
        "Foltik/vyoS" = "/root/terraform-provider-vyos"
        "goauthentik/authentik" = "/root/terraform-provider-authentik"
        "DNSMadeEasy/dme" = "/root/go/bin"
    }

    direct {}
    }
   ```

### Debugging Terraform provider

1. Start terraform plugin in debug mode: `<BINARY> -debug`.
   - provider must support debugging: see [SDK instructions](https://www.terraform.io/plugin/sdkv2/debugging)
   - in Visual Code the following block might be used under `<provider source code>/.vscode/launch.json`:
     ```
     {
        "version": "0.2.0",
        "configurations": [
            
            {
                "name": "Debug Terraform Provider",
                "type": "go",
                "request": "launch",
                "mode": "debug",
                // this assumes your workspace is the root of the repo
                "program": "${workspaceFolder}",
                "env": {},
                "args": [
                    "-debug",
                ]
            }
        ]
     }
     ```
2. Follow the instructions to run terraform using the debugged provider. Usually `TF_REATTACH_PROVIDERS={...} terraform apply`
