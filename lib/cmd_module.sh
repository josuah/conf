
cmd_module_install() {
	local name="$1"
	local path_template="$etc/module/$name/template"
	local path_file="$etc/module/$name/file"

	mkdir -p "$tmp/module/$name"

	if [ -d "$path_file" ]; then
		cp -rf "$path_file/"* "$tmp/$module/$name"
	fi

	if [ -d "$path_template" ]; then
		(cd "$path_template"; find * -type f) | while read x; do
			mkdir -p "$(dirname "$tmp/module/$name/$x")"
			(cd "$etc/var"; adm-template >$tmp/module/$name/$x) \
			  <$path_template/$x
		done
	fi

	if [ -d "$path_file" ] || [ -d "$path_template" ]; then
		cp -r "$tmp/module/$name"* "/etc/$name"
	fi

	if [ -f "$etc/module/$name/deploy.sh" ]; then
		(cd "$etc/module/$name"; . "$etc/module/$name/deploy.sh")
	fi
}
