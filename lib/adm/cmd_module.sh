
cmd_module_install() {
	local name="$1"
	local i="$etc/module/$name"
	local o="$tmp/module/$name"

	mkdir -p "$o/etc" "$o/var"

	if [ -f "$i/deploy.pre.sh" ]; then
		(cd "$i"; . ./deploy.pre.sh)
	fi

	while read x; do
		[ -f "$i/$x" ] || continue
		mkdir -p "$(dirname "$o/$x")"
		(cd "$etc/db"; adm-db "$i/$x" template) >$o/$x
	done <<EOF
$(cd "$i" && find etc var -type f 2>/dev/null)
EOF
	cp -r "$o/etc" "$o/var" /

	if [ -f "$i/deploy.post.sh" ]; then
		(cd "$i"; . ./deploy.post.sh)
	fi
}
