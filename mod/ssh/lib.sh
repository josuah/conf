deploy_pre() { set -eu
	if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
		ssh-keygen -A
	fi

	for dir in /root /srv/git; do
		mkdir -p	"$dir/.ssh/sock"
		touch		"$dir/.ssh/authorized_keys"
		chmod 644 	"$dir/.ssh/"*
		chmod 700	"$dir/.ssh/"*"/"
		chmod 755	"$dir/.ssh"
		chown -R 0:0	"$dir/.ssh"
		cat keys/*	>$dir/.ssh/authorized_keys
	done
}
