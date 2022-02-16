CONF = backup.conf cron/backup
include conf/mk/conf.mk

crontab: cron/backup

conf: /home/backup
/home/backup:
	useradd -m backup
	chmod g+s /home/backup
