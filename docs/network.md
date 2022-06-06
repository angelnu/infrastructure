# Network

## Overview

The core of the network is a set of [Vyos routers] configured in HA mode and able to leverage 2 WAN connections. The Vyos currently
active is also listing for incoming wireguard connections.

![Network overview](pictures/home-network.drawio.svg)

The home network is divided in non overlapping segments so, beyond the WANs, all IPs are routable. This allows:

- remote devices connected via wireguard to casa96 connect to devices in casa128
- Madrid devices to connect to WAN devices

## Physical network with Unifi

The casa97 phisicall network is implemented with Unifi switches. This allows to:
- assign switch ports to a subnetwork/VLAN
- discover where devices are connected to

## List of network devices

Known devices are assigned static IP addresses.

### Known devices

There are different types:

- `192.168.0.0/24` for those known devices using hardcoded IPs
- `192.168.1.0/24` for production K8S services using hardcoded IPs
- `192.168.2.0/24` for those known devices using DHCP
- `192.168.4.0/24` for Proxmox nodes using hardcoded IPs
- `192.168.11.0/24` for staging K8S services using hardcoded IPs

Known devices are listed under the [network_clients.yaml file](../settings/network_clients.yaml) with their MAC and IP addresses. This file
is used for Unifi and the Vyos DHCP/DNS server. This allows pinging them with under `<device name>` or `<device name>.lan`

K8S services are assigned their IPs within their [Gitops Flux configuration](https://github.com/fluxcd/flux2):

- [production](https://github.com/angelnu/k8s-gitops/blob/main/settings/production/settings.yaml)
- [staging](https://github.com/angelnu/k8s-gitops/blob/main/settings/staging/settings.yaml)

### Unknown devices

They get IPs assigned via DCHP from the `192.168.10.0/24` range