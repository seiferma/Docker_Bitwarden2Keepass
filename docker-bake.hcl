variable "KEEPASS_VERSION" {
  # renovate: datasource=custom.keepass depName=keepass versioning=loose
  default = "2.61"
}

variable "BITWARDEN_VERSION" {
  # renovate: datasource=npm depName=@bitwarden/cli
  default = "2026.1.0"
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/bitwarden2keepass:latest", "quay.io/seiferma/bitwarden2keepass:${BITWARDEN_VERSION}"]
  args = {
    KEEPASS_VERSION = "${KEEPASS_VERSION}"
    BITWARDEN_VERSION = "${BITWARDEN_VERSION}"
  }
}
