WEECHAT = /home/weechat/.local/share/weechat

conf: ${WEECHAT}/python /home/weechat/shell.sh

${WEECHAT}/python: ${WEECHAT}
	ln -sf /etc/conf/weechat/python ${WEECHAT}

${WEECHAT}: /home/weechat
	mkdir -p $@

/home/weechat/shell.sh: /home/weechat
	ln -sf /etc/conf/shell/weechat.sh $@
	chsh -s $@ weechat

/home/weechat:
	useradd -m weechat
