WEECHAT = /home/weechat/.local/share/weechat

conf: ${WEECHAT}/python /home/weechat/shell.sh

.PHONY: ${WEECHAT}/python
${WEECHAT}/python: ${WEECHAT}
	cp -r /etc/conf/weechat/python ${WEECHAT}

.PHONY: ${WEECHAT}
${WEECHAT}: /home/weechat
	mkdir -p $@
	chown -R weechat:weechat ${WEECHAT}

/home/weechat/shell.sh: /home/weechat
	cp /etc/conf/shell/weechat.sh $@
	chsh -s $@ weechat

/home/weechat:
	useradd -m weechat
