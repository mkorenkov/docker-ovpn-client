# docker-ovpn-client
OpenVPN client for docker made right

I use it as a NordVPN client.
You would have to download ovpn file from their site and also prepare the auth.txt file with your login on line 1, password on line 2.

```
docker run -d \
    --dns 8.8.8.8 \
    -p 8118:8118 \
    -v <ovpn_path>:/vpn/config.ovpn \
    -v <auth_txt_path>:/vpn/auth.txt \
    --cap-add=NET_ADMIN \
    --name ovpn \
    mkorenkov/ovpn:latest
```

This will expose HTTP proxy on port 8118 (privoxy).

Usage:

```
curl -x "http://127.0.0.1:8118" ipinfo.io/ip
```