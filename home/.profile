export PATH="/bin:/sbin:/usr/bin:/usr/sbin$(printf :%s /usr/*/sbin /usr/*/bin)"
export MAIL="$HOME/Maildir/"
export ENV="$HOME/.profile"
export LC_ALL="en_US.UTF-8"

case " ${ok:-false} $- " in
(" false "*i*" ")
	export EDITOR="vim"
	export PAGER="less -S"
	export MANPAGER="less"
	export LESSHISTFILE="/tmp/lesshist"
	export PS1="$(hostname -s):\$PWD\\\$\${?#0} "

	if [ -z "$SSH_CONNECTION" ]; then
		export SSH_AUTH_SOCK="$HOME/.ssh/auth.sock"
		if ! pgrep -fx "ssh-agent -a $SSH_AUTH_SOCK"; then
			rm -f "$SSH_AUTH_SOCK"
			ssh-agent -a "$SSH_AUTH_SOCK"
		fi
	fi

	set -o emacs 2>"/dev/null"
	;;
esac

ok=true
