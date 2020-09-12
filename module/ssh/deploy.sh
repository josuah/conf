if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
	ssh-keygen -A
fi
