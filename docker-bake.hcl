variable "KEEPASS_VERSION" {
  # renovate: datasource=custom.keepass depName=keepass versioning=loose
  default = "2.58"
}

variable "BITWARDEN_VERSION" {
  # renovate: datasource=npm depName=@bitwarden/cli
  default = "2025.10.0"
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/bitwarden2keepass:latest"]
  args = {
    KEEPASS_VERSION = "${KEEPASS_VERSION}"
    BITWARDEN_VERSION = "${BITWARDEN_VERSION}"
  }
}
