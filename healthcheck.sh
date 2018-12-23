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

check_openvpn || (echo "openvpn is not running" && exit 1)
check_zeroproxy || (echo "zeroproxy is not running" && exit 1)