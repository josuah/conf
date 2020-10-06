deploy_post() { set -eu
	send "
		pkill -HUP dovecot

		newaliases
		smtpctl update table aliases
	"
}
