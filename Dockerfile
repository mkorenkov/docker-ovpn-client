FROM mkorenkov/go:latest as builder

COPY ./zeroproxy /srv/go/src/zeroproxy
ENV GOPATH="/srv/go"
RUN export SRC_DIR="/srv/go/src" && \
    cd "$SRC_DIR/zeroproxy" && \
    go build -o "/usr/local/bin/zeroproxy"

FROM mkorenkov/alpine:latest

RUN apk --no-cache --no-progress add \
        bash \
        curl \
        ip6tables \
        iptables \
        openvpn && \
    apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ daemontools && \
    rm  -rf /tmp/* /var/cache/apk/*

COPY --from=builder /usr/local/bin/zeroproxy /usr/local/bin/zeroproxy
COPY ./services/ /services/
COPY entry.sh /usr/local/bin/entry.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

VOLUME ["/vpn/config.ovpn", "/vpn/auth.txt"]
EXPOSE 8118

HEALTHCHECK --interval=20s --timeout=15s --start-period=90s --retries=3 CMD [ "/usr/local/bin/healthcheck.sh" ]

ENTRYPOINT ["/usr/local/bin/entry.sh"]
