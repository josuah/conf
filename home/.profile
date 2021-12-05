export PATH="$(printf %s: /usr/*/sbin /usr/*/bin)/bin:/sbin:/usr/bin:/usr/sbin"
export PATH="$PATH:$HOME/bin"
export MAIL="$HOME/Maildir"
export EMAIL="me@josuah.net"
export ENV="$HOME/.profile"
export LC_ALL="en_US.UTF-8"
export EDITOR="vi"
export PAGER="less -SR"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export PS1="$(hostname -s)\\\$ "
export LC_ALL=en_US.UTF-8

set -o emacs
umask 002
