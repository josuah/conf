
cmd_group_install() { set -eu
	send "getent group '$1' >/dev/null || addgroup '$1'"
}
