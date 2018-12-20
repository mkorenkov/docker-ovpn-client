#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
#Unofficial Bash Strict Mode http://redsymbol.net/articles/unofficial-bash-strict-mode/

check_openvpn() {
	pgrep openvpn &>/dev/null
}

check_privoxy() {
	pgrep privoxy &>/dev/null
}

check_openvpn || (echo "openvpn is not running" && exit 1)
check_privoxy || (echo "privoxy is not running" && exit 1)