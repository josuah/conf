export PATH="/bin:/sbin:/usr/bin:/usr/sbin$(printf :%s /usr/*/sbin /usr/*/bin)"
export MAIL="/var/mail/$USER/Maildir"
export ENV="$HOME/.profile"
export LESS="XSR"
export EDITOR="vim"
export PAGER="less"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export LC_COLLATE="C"
export LC_ALL="en_US.UTF-8"

case $- in
(*i*)
	export PS1="\$USER@$(hostname -s):\$PWD%\${?#0} "
	export SSH_AUTH_SOCK="$HOME/.ssh/sock/agent"

	set -o emacs 2>"/dev/null"

	if [ -z "$SSH_CLIENT" ] &&
	! pgrep -fx "ssh-agent -a $SSH_AUTH_SOCK" >/dev/null; then
		rm -f "$SSH_AUTH_SOCK"
		ssh-agent -a "$SSH_AUTH_SOCK"
	fi
	;;
esac
