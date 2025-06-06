resource "authentik_service_connection_kubernetes" "local" {
  name  = "local"
  local = true
}

resource "authentik_outpost" "ingress_outpost" {
  name = "ingress"
  protocol_providers = [
    authentik_provider_proxy.default_ingress.id
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
    kubernetes_namespace: authentik
    kubernetes_ingress_annotations:
      hajimari.io/enable: "false"
      nginx.ingress.kubernetes.io/enable-global-auth: "false"
    kubernetes_ingress_secret_name: authentik-outpost-tls
    kubernetes_service_type: ClusterIP
    kubernetes_disabled_components: ["ingress"]
    kubernetes_image_pull_secrets: []
    kubernetes_json_patches:
      deployment:
      - op: add
        path: /spec/template/spec/volumes
        value:
          - name: shm-volume
            emptyDir:
              medium: Memory
              sizeLimit: 1Gi # Example: 1 GiB
      - op: add
        path: /spec/template/spec/containers/0/volumeMounts
        value:
          - name: shm-volume
            mountPath: /dev/shm
    EOT
  ))
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
    kubernetes_namespace: authentik
    kubernetes_ingress_annotations: {}
    kubernetes_ingress_secret_name: authentik-outpost-tls
    kubernetes_service_type: ClusterIP
    kubernetes_disabled_components: []
    kubernetes_image_pull_secrets: []
    EOT
  ))
}