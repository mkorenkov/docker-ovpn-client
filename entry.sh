#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
#Unofficial Bash Strict Mode http://redsymbol.net/articles/unofficial-bash-strict-mode/

exec /usr/bin/svscan /services 2>&1