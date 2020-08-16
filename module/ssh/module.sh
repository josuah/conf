o service sshd
o copy sshd_config
o exec && {
	ssh-keygen -A
}
