resource "authentik_stage_authenticator_validate" "validate" {
  name = "authenticator-validate"
  device_classes = ["static",
    "totp",
    "webauthn",
    "duo",
  ]
  not_configured_action = "skip"
}

resource "authentik_stage_authenticator_validate" "validate_headless" {
  name = "authenticator-validate-headless"
  device_classes = ["duo",
  ]
  not_configured_action = "skip"
}