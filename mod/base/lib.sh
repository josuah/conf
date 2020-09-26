
deploy_pre() { set -eu
	cp -rf home/.??* "$HOME"
	mkdir -p "$HOME/.ssh/sock"
	touch "$HOME/.ssh/config_local"
}

deploy_post() { set -eu
	cat /etc/crontab.d/* >/etc/crontab
	pkill -HUP cron
}
