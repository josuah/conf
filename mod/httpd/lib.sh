deploy_pre() {
	for x in $(send "ls /etc/ssl/acme"); do
		mkdir -p "$dest/etc/ssl/acme/$x"
		(cd "$etc" && dom="$x" adm-db "$conf/acme.conf" template) \
			>$dest/etc/ssl/acme/$x/acme.conf
	done
}
