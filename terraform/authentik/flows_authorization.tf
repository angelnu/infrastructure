resource "authentik_flow" "authorization_implicit_consent" {
  name        = "Authorization Implicit Consent"
  title       = "Authorization with implicit consent"
  slug        = "authorization-implicit-consent"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "authorization"
}
