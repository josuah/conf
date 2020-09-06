
_module_template() (
	cd "$etc/db"
	exec >$tmp/module/$name/${1%.template}
	adm-db template "$etc/module/$name/$1"
)

cmd_module_install() {
	local name="$1" exit=0
	set -e

	if [ -d "$etc/module/$name/etc" ]; then
		while read x; do
			mkdir -p "$(dirname "$tmp/module/$name/$x")"

			case $x in
			(*.template)
				_module_template "$x" || exit 1
				;;
			(*)
				cp "$etc/module/$name/$x" "$tmp/module/$name/$x"
				;;
			esac
		done <<EOF
$(cd "$etc/module/$name"; find etc -type f)
EOF
		cp -r "$tmp/module/$name/etc" "/"
	fi

	if [ -f "$etc/module/$name/deploy.sh" ]; then
		(cd "$etc/module/$name"; . "$etc/module/$name/deploy.sh")
	fi
}
