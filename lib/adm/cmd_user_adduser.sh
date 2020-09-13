
cmd_user_install() {
	local user="$1"
	local h="${var_path:-/var/empty}"
	local s="${var_shell:-/sbin/nologin}"
	local g="${var_group:-nogroup}"

	id -u "$u" >/dev/null 2>&1 && deluser "$u"
        adduser -D -h "$h" -s "$s" -g "$g" "$user"
}
