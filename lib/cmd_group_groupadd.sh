
cmd_group_install() { set -eu
	send "getent group '$name' >/dev/null || groupadd '$name'"
}
