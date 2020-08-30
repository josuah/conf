
cmd_module_install() {
	local name="$1"
	local path_template="$etc/module/$name/template"

	if [ -d "$etc/module/$name/etc" ]; then
		(cd "$etc/module/$name"; find etc -type f) | while read x; do
			mkdir -p "$(dirname "$tmp/module/$x")"

			case $x in
			(*.template)
				(cd "$etc/data"; adm-template) \
				  <$etc/module/$name/$x \
				  >$tmp/module/${x%.template}
				;;
			(*)
				cp "$etc/module/$name/$x" "$tmp/module/$x"
				;;
			esac
		done

		cp -r "$tmp/module/etc" "/"
	fi

	if [ -f "$etc/module/$name/deploy.sh" ]; then
		(cd "$etc/module/$name"; . "$etc/module/$name/deploy.sh")
	fi
}
