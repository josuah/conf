
cmd_golang_install() { set -eu
	local cmd="${var_cmd:-$1}"

	send "type '$cmd' >/dev/null || GOPATH=/usr/go go get '$var_url'"
}
