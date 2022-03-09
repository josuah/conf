CONF =	monitower.conf cron/monit
include conf/mk/conf.mk

crontab: cron/monit

conf: monitower
monitower:
	ln -sf conf/monitower .
