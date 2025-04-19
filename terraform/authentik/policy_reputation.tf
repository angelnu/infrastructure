resource "authentik_policy_reputation" "reputation" {
  name              = "reputation"
  check_ip          = true
  check_username    = true
  execution_logging = false
  threshold         = -5
}