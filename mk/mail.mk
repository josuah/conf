CONF = mail/smtpd.conf

mk/mail: ${CONF}

mk/mail/sync:
mk/mail/clean:

include mk/conf.inc
