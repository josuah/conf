
cmd_golang_install() { set -eu
	type "${var_cmd:-$1}" >/dev/null && return 0
	GOPATH=/usr/go go get "$1"
}
