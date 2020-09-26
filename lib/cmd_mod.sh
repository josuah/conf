
cmd_mod_install() { set -eu
	local name="$1"
	local conf="$etc/mod/$name"
	local dest="$tmp/mod/$name"

	. "$etc/mod/$name/lib.sh"

	mkdir -p "$dest/etc" "$dest/var"

	(type deploy_pre >/dev/null && cd "$conf" && deploy_pre)

	for x in $(cd "$conf" && find etc var -type f 2>/dev/null); do
		[ -f "$conf/$x" ] || continue
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc" && adm-db "$conf/$x" template >$dest/$x)
	done
	scp -qr "$dest/etc" "$dest/var" "$host:/"

	(type deploy_post >/dev/null && cd "$conf" && deploy_post)

	true
}
