FROM node:alpine AS downloader

ARG KEEPASS_VERSION

RUN wget -O /tmp/keepass.zip https://sourceforge.net/projects/keepass/files/KeePass%202.x/$KEEPASS_VERSION/KeePass-$KEEPASS_VERSION.zip && \
    wget -O /tmp/kpscript.zip https://keepass.info/extensions/v2/kpscript/KPScript-$KEEPASS_VERSION.zip && \
    unzip /tmp/keepass.zip -d /tmp/keepass && \
    unzip /tmp/kpscript.zip -d /tmp/keepass


FROM node:alpine

ARG BITWARDEN_VERSION
ENV BW_URL=""
ENV BW_CLIENTID=""
ENV BW_CLIENTSECRET=""

# Add scripts
COPY /scripts/* /usr/bin/
COPY empty.kdbx /empty.kdbx

# Configure image
ENTRYPOINT ["/usr/bin/convert_bitwarden_to_keepass"]

# Install system dependencies
ENV PNPM_HOME=/opt/pnpm
ENV PATH="$PATH:$PNPM_HOME"
RUN apk add --no-cache jq mono pnpm bash libgdiplus && \
    mkdir "$PNPM_HOME"

# Install keepass
COPY --from=downloader /tmp/keepass /opt/keepass

# Install bitwarden cli
RUN pnpm add -g @bitwarden/cli@$BITWARDEN_VERSION
