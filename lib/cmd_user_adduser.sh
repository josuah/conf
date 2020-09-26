
cmd_user_install() { set -eu
	local user="$1"
	local home="${var_path:-/var/empty}"
	local shell="${var_shell:-/sbin/nologin}"
	local group="${var_group:-nogroup}"
	local check="id -u '$user' >/dev/null 2>&1"
	local argv="-h '$home' -s '$shell' -g '$group' '$user'"

	send "$check || exec adduser $argv"
}
