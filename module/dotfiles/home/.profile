export PATH=/bin:/sbin:/usr/bin:/usr/sbin
for path in /usr/*/bin /usr/*/sbin; do
	[ -d "$path" ] && export PATH="$PATH:$path"
done

export MAIL="/var/mail/$USER/Maildir"
export ENV="$HOME/.profile"

export LC_COLLATE="C"
export LC_ALL="en_US.UTF-8"

export LESS="XSR"
export EDITOR="vim"
export PAGER="less"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"

case $(uname) in
(NetBSD)
	export PKG_PATH="http://cdn.NetBSD.org/pub/pkgsrc/packages"
	export PKG_PATH="$PKG_PATH/$(uname -s)/$(uname -m)"
	export PKG_PATH="$PKG_PATH/$(uname -r | cut -d . -f 1-2)/All/"
	;;
esac

case $- in
(*i*)
	export TERM="xterm-256color"
	export PS1="\$USER@$(hostname -s):\$PWD%\${?#0} "
	export SSH_AUTH_SOCK="$HOME/.ssh/sock/agent"

	set -o emacs 2>"/dev/null"

	if [ -z "$SSH_CLIENT" ] &&
	! pgrep -fx "ssh-agent -a $SSH_AUTH_SOCK"; then
		rm -f "$SSH_AUTH_SOCK"
		ssh-agent -a "$SSH_AUTH_SOCK"
	fi
	;;
esac