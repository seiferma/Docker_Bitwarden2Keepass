variable "VERSION" {
  default = "latest"
}

group "default" {
  targets = ["default"]
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/bitwarden2keepass:${VERSION}"]
  args = {
    KEEPASS_VERSION = "2.54"
  }
}
