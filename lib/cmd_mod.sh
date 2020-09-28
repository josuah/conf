cmd_mod_install() { set -eu
	local name="$1"
	export conf="$etc/mod/$name"
	export dest="$etc/mod/$name/tmp"
	local trap="rm -rf '$etc/mod/'*'/tmp'"

	trap "$trap" INT TERM EXIT HUP
	mkdir -p "$dest/etc" "$dest/var"

	. "$etc/mod/$name/lib.sh"

	(type deploy_pre >/dev/null && cd "$conf" && deploy_pre)

	for x in $(cd "$conf" && find etc var -type f 2>/dev/null); do
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc" && adm-db "$conf/$x" template >$dest/$x)
	done
	scp -qr "$dest/etc" "$dest/var" "$host:/"

	(type deploy_post >/dev/null && cd "$conf" && deploy_post)

	sh -c "$trap"
}
