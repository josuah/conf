export PATH="$(printf %s: /usr/*/sbin /usr/*/bin)/bin:/sbin:/usr/bin:/usr/sbin"
export PATH="$PATH:$HOME/.local/bin"
export MAIL="$HOME/Maildir"
export ENV="/etc/profile"
export LC_ALL="en_US.UTF-8"
export EDITOR="vi"
export PAGER="less -SR"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export PS1='\u@\h:$PWD% '
export LC_ALL=en_US.UTF-8

[ -f "$HOME/.profile" ] && . "$HOME/.profile"
set -o emacs
