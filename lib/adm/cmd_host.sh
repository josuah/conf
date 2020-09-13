
cmd_host_sync() {
	local host="$1" ref=${var_git:-master}
	local dest=var/lib/adm
	local commit=$(git rev-parse "$ref")
	local archive=archive-$(date +%s)-$commit-$ref

	git -c tar.umask=022 archive --prefix="$dest/$archive/" "$commit" \
	| ssh "$host" "
		tar -x -C / -f -
		mkdir -p /etc/adm/local
		ln -sf '/$dest/$archive/'* /etc/adm
		ls -rd '/$dest/'* | sed 1,4d | xargs rm -rf
		make -C /etc/adm update
	"
}
