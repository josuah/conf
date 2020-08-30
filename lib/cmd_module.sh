
_module_template() (
	cd "$etc/data"
	adm-template "$etc/module/$name/$1" >$tmp/module/${1%.template}
)

cmd_module_install() {
	local name="$1"

	if [ -d "$etc/module/$name/etc" ]; then
		while read x; do
			mkdir -p "$(dirname "$tmp/module/$x")"

			case $x in
			(*.template)
				_module_template "$x" || exit 1
				;;
			(*)
				cp "$etc/module/$name/$x" "$tmp/module/$x"
				;;
			esac
		done <<EOF
$(cd "$etc/module/$name"; find etc -type f)
EOF
		cp -r "$tmp/module/etc" "/"
	fi

	if [ -f "$etc/module/$name/deploy.sh" ]; then
		(cd "$etc/module/$name"; . "$etc/module/$name/deploy.sh")
	fi
}
