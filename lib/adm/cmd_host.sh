
cmd_host_sync() {
	local host="$1" ref=${var_git:-master}
	local dest=var/lib/adm
	local commit=$(git rev-parse "$ref")
	local archive=archive-$(date +%s)-$commit-$ref

	git -c tar.umask=022 archive --prefix="$dest/$archive/" "$commit" \
	| ssh "$host" "
		tar -x -C / -f -
		cd '/$dest'
		ln -s '$archive' '$archive/current'
		mv '$archive/current' .
		ls -r | grep '^archive-' | grep -Fvx "$archive" | sed 1,4d | xargs rm -rf
		make -C current update
	"
}
