deploy_pre() { set -eux
	[ "${user:-root}" = root ] && home="root" || home="home/$user"

	mkdir -p "$dest/$home"
	cp -rf dot/.??* "$dest/$home"
	ls -a "$dest/$home"

	mkdir -p "$dest/$home/.ssh/sock"
	cat keys/* >$dest/$home/.ssh/authorized_keys
}
