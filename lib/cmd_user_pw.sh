
cmd_user_install() { set -eu
	local home="${path:-/var/empty}"
	local shell="${shell:-/sbin/nologin}"
	local group="${group:-nogroup}"

	send "
		id -u '$name' >/dev/null 2>&1 || exec adduser -h'$home' -s'$shell' -g'$group' '$name'"
	"
}
