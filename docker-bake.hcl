target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/bitwarden2keepass:latest"]
  args = {
    # renovate: datasource=custom.keepass depName=keepass
    KEEPASS_VERSION = "2.58"
  }
}
