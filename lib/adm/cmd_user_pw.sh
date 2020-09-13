
cmd_user_install() {
	local user="$1"
	local h="${var_path:-/var/empty}"
	local s="${var_shell:-/sbin/nologin}"
	local g="${var_group:-nogroup}"
	local cmd

	id -u "$user" >/dev/null 2>&1 && cmd=usermod || cmd=useradd
	pw "$cmd" "$user" -d "$h" -s "$s" -g "$g"
}
