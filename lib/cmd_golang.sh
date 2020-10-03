
cmd_golang_install() { set -eu
	local cmd="${cmd:-$1}"

	send "type '$cmd' >/dev/null || GOPATH=/usr/go go get '$url'"
}
