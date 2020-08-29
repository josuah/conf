v=0.2.17
url=https://github.com/umurmur/umurmur/archive/$v.tar.gz
sha256=e77b7b6616768f4a1c07442afe49a772692f667b00c23cc85909d4dd0ce206d2

build() {
	cc -o umurmurd \
	  -I"src" -I"$PREFIX/include" -L"$PREFIX/lib" \
	  src/Mumble.pb-c.c src/ban.c src/channel.c src/client.c src/conf.c  \
	  src/crypt.c src/log.c src/main.c src/memory.c src/messagehandler.c  \
	  src/messages.c src/pds.c src/server.c src/sharedmemory.c  \
	  src/ssli_mbedtls.c src/timer.c src/util.c src/voicetarget.c \
	  -lmbedtls -lmbedcrypto -lmbedx509 -lconfig -lprotobuf-c
	mkdir -p "$DESTDIR$PREFIX/bin"
	cp umurmurd "$DESTDIR$PREFIX/bin"
}
