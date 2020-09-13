if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
	ssh-keygen -A
fi

for dir in /root /srv/git; do
	mkdir -p	"$dir/.ssh"
	touch		"$dir/.ssh/authorized_keys"
	chmod 600 	"$dir/.ssh/"*
	chmod 700	"$dir/.ssh/"*"/" "$dir/.ssh"
	chown root	"$dir/.ssh/authorized_keys"
	cat keys/*	>$dir/.ssh/authorized_keys
done
