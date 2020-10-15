cmd_mod_install() { set -eu
	local exit=0
	local trap="rm -rf '$etc/mod/'*'/tmp'"
	export conf="$etc/mod/$name"
	export dest="$etc/mod/$name/tmp"

	trap "$trap" INT TERM EXIT HUP
	mkdir -p "$dest/etc" "$dest/var" "$dest/home" "$dest/root"

	. "$etc/mod/$name/lib.sh"

	if type deploy_pre >/dev/null; then
		(cd "$conf" && deploy_pre) || exit 1
	fi

	for x in $(cd "$conf" && find etc var -type f 2>/dev/null); do
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc" && dbase "$conf/$x" template >$dest/$x)
	done

	scp -qr "$dest/etc" "$dest/var" "$dest/root" "$dest/home" \
	  "${user:-root}@$host:/"

	if type deploy_post >/dev/null; then
		(cd "$conf" && deploy_post) || exit 1
	fi

	sh -c "$trap"
	return "${exit:-0}"
}
