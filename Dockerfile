FROM --platform=$BUILDPLATFORM alpine:latest AS downloader-kp
ARG KEEPASS_VERSION
RUN wget -O /tmp/keepass.zip https://sourceforge.net/projects/keepass/files/KeePass%202.x/$KEEPASS_VERSION/KeePass-$KEEPASS_VERSION.zip && \
    wget -O /tmp/kpscript.zip https://keepass.info/extensions/v2/kpscript/KPScript-$KEEPASS_VERSION.zip && \
    unzip /tmp/keepass.zip -d /tmp/keepass && \
    unzip /tmp/kpscript.zip -d /tmp/keepass


FROM --platform=$BUILDPLATFORM alpine:latest AS downloader-bw
ARG TARGETARCH
ARG BITWARDEN_VERSION
WORKDIR /tmp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        URL="https://github.com/bitwarden/clients/releases/download/cli-v$BITWARDEN_VERSION/bw-linux-$BITWARDEN_VERSION.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        URL="https://github.com/bitwarden/clients/releases/download/cli-v$BITWARDEN_VERSION/bw-linux-arm64-$BITWARDEN_VERSION.zip"; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; \
        exit 1; \
    fi && \
    wget -O /tmp/bw.zip "$URL" && \
    unzip /tmp/bw.zip  && \
    chmod +x /tmp/bw


FROM bitnami/minideb:latest

ENV BW_URL=""
ENV BW_CLIENTID=""
ENV BW_CLIENTSECRET=""

# Add scripts
COPY /scripts/* /usr/bin/
COPY empty.kdbx /empty.kdbx

# Configure image
ENTRYPOINT ["/usr/bin/convert_bitwarden_to_keepass"]

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends jq mono-runtime libmono-system-windows-forms4.0-cil bash && \
    rm -rf /var/lib/apt/lists/*

# Install keepass
COPY --from=downloader-kp /tmp/keepass /opt/keepass

# Install bitwarden cli
COPY --from=downloader-bw /tmp/bw /usr/local/bin/bw
