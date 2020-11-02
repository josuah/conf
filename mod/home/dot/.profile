export PATH="/bin:/sbin:/usr/bin:/usr/sbin$(printf :%s /usr/*/sbin /usr/*/bin)"
export MAIL="$HOME/Maildir/"
export ENV="$HOME/.profile"
export LC_ALL="en_US.UTF-8"
export PLAN9_CPU=10.191.254.11

case " ${ok:-false} $- " in
(" false "*i*" ")
	export EDITOR="vim"
	export PAGER="less"
	export MANPAGER="less"
	export LESSHISTFILE="/tmp/lesshist"
	export PS1="$(hostname -s):\$PWD\\\$\${?#0} "

	if [ -z "$SSH_CONNECTION" ]; then
		export SSH_AUTH_SOCK="$HOME/.ssh/sock/agent"
		if ! pgrep -fx "ssh-agent -a $SSH_AUTH_SOCK" >/dev/null; then
			rm -f "$SSH_AUTH_SOCK"
			ssh-agent -a "$SSH_AUTH_SOCK"
		fi
	fi
	;;
esac

set -o emacs 2>"/dev/null"
ok=true
