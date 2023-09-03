FROM ubuntu:rolling AS downloader

ARG KEEPASS_VERSION

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget -O /tmp/keepass.zip https://deac-riga.dl.sourceforge.net/project/keepass/KeePass%202.x/$KEEPASS_VERSION/KeePass-$KEEPASS_VERSION.zip && \
    wget -O /tmp/kpscript.zip https://keepass.info/extensions/v2/kpscript/KPScript-$KEEPASS_VERSION.zip && \
    unzip /tmp/keepass.zip -d /tmp/keepass && \
    unzip /tmp/kpscript.zip -d /tmp/keepass



FROM ubuntu:rolling

RUN apt-get update && \
    apt-get install -y xvfb libgtk2.0-0 `apt-cache depends keepass2 | awk '/Depends:/{print$2}'` && \
    rm -rf /var/lib/apt/lists/*

COPY --from=downloader /tmp/keepass /opt/keepass
COPY /scripts/* /usr/bin/
COPY empty.kdbx /empty.kdbx

ENTRYPOINT ["/usr/bin/convert_bitwarden_to_keepass"]
