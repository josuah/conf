CONF = mail/smtpd.conf
include mk/conf.inc

mk/mail: ${CONF}
mk/mail/sync:
mk/mail/clean:
