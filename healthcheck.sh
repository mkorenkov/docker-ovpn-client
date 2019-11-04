#!/bin/bash
#Unofficial Bash Strict Mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

check_openvpn() {
	pgrep openvpn &>/dev/null
}

check_zeroproxy() {
	pgrep zeroproxy &>/dev/null
}

check_default_route() {
	ip route | grep 0.0.0.0 | grep -q "tun0"
}

# NOTE: ping does not work realiably in docker for OSX
# https://forums.docker.com/t/ping-from-within-a-container-does-not-actually-ping/11787/12
#
# So, instead, let's curl google.com and facebook.com

curl4() {
	curl -s -o /dev/null -w '%{http_code}' "$1"
}

curl6() {
	curl -6 -s -o /dev/null -w '%{http_code}' "$1"
}

healthcheck_facebook() {
	# check HTTP HEAD gets a redirect
	url="http://facebook.com"
	res1="$(curl4 $url || true)"
	res2="$(curl6 $url || true)"
	[[ $res1 -eq 302 || $res2 -eq 302 ]]
}

healthcheck_google() {
	# check HTTP HEAD gets a redirect
	url="http://google.com"
	res1="$(curl4 $url || true)"
	res2="$(curl6 $url || true)"
	[[ $res1 -eq 301 || $res2 -eq 301 ]]
}

check_openvpn || (echo "openvpn is not running" && exit 11)
check_zeroproxy || (echo "zeroproxy is not running" && exit 21)
check_default_route || (echo "default route is not openvpn" && exit 31)
( healthcheck_google || healthcheck_facebook ) || (echo "HTTP healthcheck of google.com and facebook.com has failed" && exit 41)

