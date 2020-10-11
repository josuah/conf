deploy_post() {
	domain=sip$(dbase "$db/dns-sip" get "#" host="$host")
	domain=$domain.$(dbase "$db/dns-soa" get soa | sed q)

	send "
		ln -f '/etc/ssl/private/$domain.key' /etc/kamailio/hardlink.key
		ln -f '/etc/ssl/$domain.crt' /etc/kamailio/hardlink.crt
		chmod 400 /etc/kamailio/hardlink.*
		chown _kamailio /etc/kamailio/hardlink.*
	"
}
