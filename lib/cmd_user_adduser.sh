
cmd_user_install() { set -eu
	local home="${path:-/var/empty}"
	local shell="${shell:-/sbin/nologin}"
	local group="${group:-nogroup}"
	local check="id -u '$name' >/dev/null 2>&1"
	local flags="-h'$home' -s'$shell' -g'$group' '$name'"

	send "$check || exec adduser $flags"
}
