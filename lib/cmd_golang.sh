
cmd_golang_install() { set -eu
	send "type '$name' >/dev/null || GOPATH=/usr/go go get '$url'"
}
