FROM alpine:3.8

RUN apk --no-cache --no-progress add \
        bash \
        curl \
        ip6tables \
        iptables \
        openvpn \
        privoxy && \
    apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ daemontools && \
    rm  -rf /tmp/* /var/cache/apk/*

COPY ./services/ /services/
COPY default/privoxy.conf /opt/privoxy.conf
COPY entry.sh /opt/entry.sh
COPY healthcheck.sh /opt/healthcheck.sh

VOLUME ["/vpn/config.ovpn", "/vpn/auth.txt"]
EXPOSE 8118

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=3 CMD [ "/opt/healthcheck.sh" ]

ENTRYPOINT ["/opt/entry.sh"]
