export PKG_PATH="http://cdn.NetBSD.org/pub/pkgsrc/packages"
export PKG_PATH="$PKG_PATH/$(uname -s)/$(uname -m)"
export PKG_PATH="$PKG_PATH/$(uname -r | cut -d . -f 1-2)/All/"
export PATH=$PATH:/usr/pkg/libexec/git-core
