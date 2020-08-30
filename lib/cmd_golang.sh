
cmd_golang_install() {
	[ -f "${var_cmd:-$1}" ] && return 0
	GOPATH=/usr/go go get "$1"
}
