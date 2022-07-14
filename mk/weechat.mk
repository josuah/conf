WEECHAT = /home/weechat/.local/share/weechat

conf: ${WEECHAT}/python /home/weechat/shell.sh

${WEECHAT}/python: ${WEECHAT}
	cp -r /etc/conf/weechat/python ${WEECHAT}
	chown -R weechat:weechat ${WEECHAT}

${WEECHAT}: /home/weechat
	mkdir -p $@

/home/weechat/shell.sh: /home/weechat
	ln -sf /etc/conf/shell/weechat.sh $@
	chsh -s $@ weechat

/home/weechat:
	useradd -m weechat
