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

ping_ip4() {
	ping -c 4 "$1" &>/dev/null
}

ping_ip6() {
	ping -6 -c 4 "$1" &>/dev/null
}

check_ipv4() {
	addrs=("8.8.8.8" "8.8.4.4")

	for ip in ${addrs[@]}; do
		ping_ip4 "$ip" && return 0
	done
	return 1
}

check_ipv6() {
	addrs=("2001:4860:4860::8888" "2001:4860:4860::8844")

	for ip in ${addrs[@]}; do
		ping_ip6 "$ip" && return 0
	done
	return 1
}

check_openvpn || (echo "openvpn is not running" && exit 1)
check_zeroproxy || (echo "zeroproxy is not running" && exit 1)
( check_ipv6 || check_ipv4 ) || (echo "network check (ping) failed" && exit 1)