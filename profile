export PATH="$(printf %s: /usr/*/sbin /usr/*/bin)/bin:/sbin:/usr/bin:/usr/sbin"
export PATH="$PATH:$HOME/.local/bin"
export MAIL="$HOME/Maildir"
export ENV="/etc/profile"
export EDITOR="vi"
export PAGER="less -SR"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export PS1='$(hostname -s):${PWD#$HOME/}:$(git branch --show-current 2>&-)\$${?#0} '
export CVSROOT="anoncvs@anoncvs.fr.openbsd.org:/cvs"
export LC_ALL="en_US.UTF-8"

[ -f "$HOME/.profile" -a -z "$ENV" ] && . "$HOME/.profile"
set -o emacs

alias ls="LC_ALL=C ls"
