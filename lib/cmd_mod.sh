
cmd_mod_install() { set -eu
	local name="$1"
	export conf="$etc/mod/$name"
	export dest="$etc/mod/$name/tmp"
	local trap="rm -rf '$etc/mod/'*'/tmp'"

	trap "$trap" INT TERM EXIT HUP

	. "$etc/mod/$name/lib.sh"

	mkdir -p "$dest/etc" "$dest/var"

	(type deploy_pre >/dev/null && cd "$conf" && deploy_pre)

	if [ -d "$conf/bin" ]; then
		mkdir -p "$dest/usr/local"
		cp -rf "$conf/bin" "$dest/usr/local"
	fi

	for x in $(cd "$conf" && find etc var -type f 2>/dev/null); do
		[ -f "$conf/$x" ] || continue
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc" && adm-db "$conf/$x" template >$dest/$x)
	done
	scp -qr "$dest/etc" "$dest/var" "$host:/"

	(type deploy_post >/dev/null && cd "$conf" && deploy_post)

	sh -c "$trap"
}
