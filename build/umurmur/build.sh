version 0.5
archive https://github.com/umurmur/umurmur/archive/$version.tar.gz
checksum 01fff57f2231667b3c05ff865f872e1aa8f5e4455730972fb42d36ac8f6a96ba

build() {
	cc -o umurmurd \
	  -I"src" -I"$PREFIX/include" -L"$PREFIX/lib" \
	  src/Mumble.pb-c.c src/ban.c src/channel.c src/client.c src/conf.c  \
	  src/crypt.c src/log.c src/main.c src/memory.c src/messagehandler.c  \
	  src/messages.c src/pds.c src/server.c src/sharedmemory.c  \
	  src/ssli_mbedtls.c src/timer.c src/util.c src/voicetarget.c \
	  -lmbedtls -lmbedcrypto -lmbedx509 -lconfig -lprotobuf-c
	mkdir -p "$PREFIX/bin"
	cp umurmurd "$PREFIX/bin"
}
