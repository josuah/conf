
_module_hook() {
	local path="$1" hook="$2" pwd="$PWD"

	[ -f "$path/$hook" ] || return
	cd "$path"
	. "./$hook"
	cd "$pwd"
}

cmd_module_install() { set -eu
	local name="$1"
	local conf="$etc/module/$name"
	local dest="$tmp/module/$name"

	mkdir -p "$dest/etc" "$dest/var"

	_module_hook "$conf" deploy.pre.sh

	while read x; do
		[ -f "$conf/$x" ] || continue
		mkdir -p "$(dirname "$dest/$x")"
		(cd "$etc/db" && adm-db "$conf/$x" template >$dest/$x)
	done <<EOF
$(cd "$conf" && find etc var -type f 2>/dev/null)
EOF
	cp -r "$dest/etc" "$dest/var" /

	_module_hook "$conf" deploy.post.sh
}
