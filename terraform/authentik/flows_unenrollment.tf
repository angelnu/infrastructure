resource "authentik_flow" "unenrollment" {
  name        = "terraform-unenrollment"
  title       = "Casa - logout"
  slug        = "terraform-unenrollment"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "unenrollment"
}