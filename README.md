# Docker_Bitwarden2Keepass
[![](https://github.com/seiferma/Docker_Bitwarden2Keepass/actions/workflows/docker-deploy.yml/badge.svg?branch=main)](https://github.com/seiferma/Docker_Bitwarden2Keepass/actions?query=branch%3Amain+)
[![](https://img.shields.io/github/issues/seiferma/Docker_Bitwarden2Keepass.svg)](https://github.com/seiferma/Docker_Bitwarden2Keepass/issues)
[![](https://img.shields.io/github/license/seiferma/Docker_Bitwarden2Keepass.svg)](https://github.com/seiferma/Docker_Bitwarden2Keepass/blob/main/LICENSE)

Utility image that extracts a vault backup into a keepass2 database.

## Usage
The docker image is available under `quay.io/seiferma/bitwarden2keepass` (see the [registry page](https://quay.io/repository/seiferma/bitwarden2keepass?tab=tags) for available versions). The image is available for linux using amd64 or arm64.

You can simply run the container and specify the following parameters in this order
1. output file (newly created keepass database)
2. master password (optional)

If you omit the master password on the command line, you can either specify an environment variable `KDBX_PW` or enter the password interactively.

An example command line call looks like this:
```sh
docker run --rm \
  -v /tmp/kdbx_output:/tmp/output \
  quay.io/seiferma/bitwarden2keepass \
  /tmp/output/vault.kdbx \
  changeme
```

This yields a keepass database with master password `changeme` in `/tmp/kdbw_output` in your host system.

## Technical Background

The image extracts the vault contents via the official bitwarden cli client. The unencrypted JSON files are imported into an empty keepass2 database. The import takes place in the official keepass implementation, which we run in mono.