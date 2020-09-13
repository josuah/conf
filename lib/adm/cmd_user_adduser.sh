
cmd_user_install() {
	local user="$1"
	local h="${var_path:-/var/empty}"
	local s="${var_shell:-/sbin/nologin}"
	local g="${var_group:-nogroup}"

	if id -u "$u" >/dev/null; then
		deluser "$u"
	fi

        adduser -D -h "$h" -s "$s" -g "$g" "$user"
}
