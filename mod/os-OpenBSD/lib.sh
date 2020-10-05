deploy_post() {
	pub='"/etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub"'
	url='https://cdn.openbsd.org/pub/OpenBSD/"$(uname -r)"'

	send "
		if [ ! -d /usr/ports ]; then
			cd /tmp
			ftp $url/ports.tar.gz $url/SHA256.sig
			signify -Cp $pub -x SHA256.sig ports.tar.gz
			cd /usr
			tar xzf /tmp/ports.tar.gz
			rm -f /tmp/ports.tar.gz
		fi
	"
}
