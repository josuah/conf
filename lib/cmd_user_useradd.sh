
cmd_user_install() { set -eu
	local user="$1"
	local home="${path:-/var/empty}"
	local shell="${shell:-/sbin/nologin}"
	local group="${group:-nogroup}"
	local check="id -u '$user' >/dev/null 2>&1"
	local flags="-d '$home' -s '$shell' -g '$group' '$user'"

	send "$check && exec usermod $flags || exec useradd $flags"
}
