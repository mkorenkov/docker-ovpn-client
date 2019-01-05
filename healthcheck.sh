#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
#Unofficial Bash Strict Mode http://redsymbol.net/articles/unofficial-bash-strict-mode/

check_openvpn() {
	pgrep openvpn &>/dev/null
}

check_zeroproxy() {
	pgrep zeroproxy &>/dev/null
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

check_openvpn || (echo "openvpn is not running" && exit 1)
check_zeroproxy || (echo "zeroproxy is not running" && exit 1)
( healthcheck_google || healthcheck_facebook ) || (echo "HTTP healthcheck of google.com and facebook.com has failed" && exit 1)
