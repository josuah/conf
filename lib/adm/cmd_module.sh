
cmd_module_install() {
	local name="$1"
	local i="$etc/module/$name"
	local o="$tmp/module/$name"

	if [ -d "$i/etc" ]; then
		while read x; do
			mkdir -p "$(dirname "$o/$x")"
			(cd "$etc/db"; adm-db "$i/$x" template) >$o/$x
		done <<EOF
$(cd "$i"; find etc -type f)
EOF
		cp -r "$o/etc" /
	fi

	if [ -f "$i/deploy.sh" ]; then
		(cd "$i"; . ./deploy.sh)
	fi
}
