deploy_pre() { set -eu
	[ "${user:-root}" = root ] && home="/root" || home="/home/$user"

	mkdir -p "$dest$home"
	cp -rf dot/.??* "$dest$home"

	mkdir -p "$dest$home/.ssh/sock"
	cat keys/* >$dest$home/.ssh/authorized_keys

	send "
		[ -f '$home/.ssh/id_ed25519' ] ||
		  ssh-keygen -t ed25519 -N '' -f '$home/.ssh/id_ed25519'
		chmod 700 '$home/.ssh'
	"
}
