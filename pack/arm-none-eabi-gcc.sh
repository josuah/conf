v=11.2.0
url=http://mirror.koddos.net/gcc/releases/gcc-$v/gcc-$v.tar.gz
dir=gcc-$v

pack_configure() {
	mkdir .bin
cat <<'EOF' >.bin/cc
#!/bin/sh -eu
export PATH="${PATH#*/.bin:}"
set -x
exec cc -I/usr/local/include -L/usr/local/lib "$@"
EOF
	chmod +x .bin/*

	export PATH="$PWD/.bin:$PATH" CC="$PWD/.bin/cc"

	./configure --prefix="$PREFIX" CC="$PWD/.bin/cc"
}

pack_build() {
	gmake
}
