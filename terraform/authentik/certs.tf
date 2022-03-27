data "authentik_certificate_key_pair" "generated" {
  name = "authentik Self-signed Certificate"
}

data "authentik_certificate_key_pair" "cluster_domain_cert" {
  name = "cluster-domain-cert"
}