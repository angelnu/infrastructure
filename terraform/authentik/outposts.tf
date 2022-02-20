resource "authentik_service_connection_kubernetes" "local" {
  name  = "local"
  local = true
}

resource "authentik_outpost" "embedded_outpost" {
  name = "authentik Embedded Outpost"
  protocol_providers = [
    authentik_provider_proxy.default_ingress.id,
    authentik_provider_proxy.kubernetes_dashboard.id,    
    authentik_provider_proxy.ha_editor.id
  ]
  service_connection = authentik_service_connection_kubernetes.local.id
}

resource "authentik_outpost" "ldap_outpost" {
  name = "ldap-outpost"
  type = "ldap"
  protocol_providers = [
    authentik_provider_ldap.ldap_app.id
  ]
  service_connection = authentik_service_connection_kubernetes.local.id
  config = jsonencode(yamldecode(<<-EOT
    authentik_host: https://authentik.pub.${var.main_home_domain}
    authentik_host_insecure: false
    authentik_host_browser: ""
    log_level: debug
    object_naming_template: ak-outpost-%(name)s
    docker_network: null
    docker_map_ports: true
    docker_labels: null
    container_image: null
    kubernetes_replicas: 1
    kubernetes_namespace: kube-system
    kubernetes_ingress_annotations: {}
    kubernetes_ingress_secret_name: authentik-outpost-tls
    kubernetes_service_type: ClusterIP
    kubernetes_disabled_components: []
    kubernetes_image_pull_secrets: []
    EOT
    ))
}