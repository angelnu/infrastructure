resource "authentik_stage_authenticator_validate" "validate" {
  name                  = "authenticator-validate"
  device_classes        = ["static",
                           "totp",
                           "webauthn",
                          ]
  not_configured_action = "skip"
}