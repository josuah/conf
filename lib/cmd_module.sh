
cmd_mod_install() { set -eu
	local name="$1"
	local conf="$etc/module/$name"
	local dest="$tmp/module/$name"

	mkdir -p "$dest/etc" "$dest/var"

	. "$conf/lib.sh"

	(type deploy_pre >/dev/null && cd "$conf" && deploy_pre)

	for x in $(cd "$conf" && find etc var -type f 2>/dev/null); do
		[ -f "$conf/$x" ] || continue
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$db" && adm-db "$conf/$x" template >$dest/$x)
	done
	cp -r "$dest/etc" "$dest/var" /

	(type deploy_post >/dev/null && cd "$conf" && deploy_post)

	true
}
