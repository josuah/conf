CONF = mail/smtpd.conf

mail: ${CONF}

mk/mail:
mk/mail/sync:
mk/mail/clean:

include mk/conf.inc
