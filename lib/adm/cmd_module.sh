
cmd_module_install() { set -eu
	local name="$1"
	local conf="$etc/module/$name"
	local dest="$tmp/module/$name"

	mkdir -p "$dest/etc" "$dest/var"

	if [ -f "$conf/deploy.sh" ]; then
		. "$conf/deploy.sh"
	fi

	(type deploy_pre >/dev/null && cd "$conf" && deploy_pre)

	while read x; do
		[ -f "$conf/$x" ] || continue
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc/db" && adm-db "$conf/$x" template >$dest/$x)
	done <<EOF
$(test -d "$conf" && cd "$conf" && find etc var -type f 2>/dev/null)
EOF
	cp -r "$dest/etc" "$dest/var" /

	(type deploy_post >/dev/null && cd "$conf" && deploy_post)

	true
}
