
cmd_host_sync() {
	local host="$1" ref=${var_git:-master}
	local dest=var/lib/adm
	local commit=$(git rev-parse "$ref")
	local archive=archive-$(date +%s)-$commit-$ref

	git -c tar.umask=022 archive --prefix="$dest/$archive/" "$commit" \
	| ssh "$host" "
		tar -x -C / -f -
		ln -s '$archive' '/$dest/$archive/current'
		cd '/$dest'
		mv '$archive/current' .
		ls -r | grep '^archive-' | grep -Fvx "$archive" | sed '1,4 d' | xargs rm -rf

		current/bin/adm install 'host/$host'
		current/bin/adm enable 'host/$host'
	"
}
