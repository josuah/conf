export PATH="$(printf %s: /usr/*/sbin /usr/*/bin)/bin:/sbin:/usr/bin:/usr/sbin"
export PATH="$PATH:$HOME/.local/bin"
export MAIL="$HOME/Maildir"
export ENV="/etc/profile"
export EDITOR="vi"
export PAGER="less -SR"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export PS1='\u@\h:$PWD% '
export CVSROOT="anoncvs@anoncvs.fr.openbsd.org:/cvs"
export LIBPYTHON_LOC="$(ldconfig -r | sed -n '/libpython3/ s/^.* // p')"
export LC_ALL="en_US.UTF-8"

[ -f "$HOME/.profile" ] && . "$HOME/.profile"
set -o emacs
