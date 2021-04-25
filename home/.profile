export PATH="/bin:/sbin:/usr/bin:/usr/sbin$(printf :%s /usr/*/sbin /usr/*/bin)"
export MAIL="$HOME/Maildir/"
export ENV="$HOME/.profile"
export LC_ALL="en_US.UTF-8"
export EDITOR="mg"
export PAGER="less -S"
export MANPAGER="less"
export LESSHISTFILE="/tmp/lesshist"
export PS1="$(hostname -s):\$PWD\\\$\${?#0} "
export LC_ALL=en_US.UTF-8
stty kerninfo
