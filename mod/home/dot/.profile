export PATH="/bin:/sbin:/usr/bin:/usr/sbin$(printf :%s /usr/*/sbin /usr/*/bin)"
export MAIL="$HOME/Maildir/"
export ENV="$HOME/.profile"
export LC_ALL="en_US.UTF-8"

set -o emacs 2>"/dev/null"

case " ${ok:-first} $- " in
(" first "*i*" ")
	export PS1="\$USER@$(hostname -s):\$PWD%\${?#0} "
	export SSH_AUTH_SOCK="$HOME/.ssh/sock/agent"
	export LESSHISTFILE="/tmp/lesshist"
	export EDITOR="vim"
	export LESS="XSR"
	export PAGER="less"
	export MANPAGER="less"

	type w >/dev/null && w

	if [ -z "$SSH_CLIENT" ] &&
	! pgrep -fx "ssh-agent -a $SSH_AUTH_SOCK" >/dev/null; then
		rm -f "$SSH_AUTH_SOCK"
		ssh-agent -a "$SSH_AUTH_SOCK"
	fi
	;;
esac
ok=true
