WEECHAT = /home/irc/.local/share/weechat

conf: ${WEECHAT}/python

${WEECHAT}/python: ${WEECHAT}
	ln -sf /etc/conf/weechat/python ${WEECHAT}

${WEECHAT}:
	mkdir -p $@

/home/irc:
	useradd -m irc
