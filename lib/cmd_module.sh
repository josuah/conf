
cmd_module_install() {
	local name="$1"
	local _etc="$etc/module/$name"
	local _tmp="$tmp/module/$name"

	if [ -d "$_etc/etc" ]; then
		while read x; do
			mkdir -p "$(dirname "$_tmp/$x")"
			(cd "$etc/db"; adm-db "$_etc/$x" template) >$_tmp/$x
		done <<EOF
$(cd "$_etc"; find etc -type f)
EOF
		cp -r "$_tmp/etc" /
	fi

	if [ -f "$_etc/deploy.sh" ]; then
		(cd "$_etc"; . ./deploy.sh)
	fi
}
