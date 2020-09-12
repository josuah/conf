v=2.24.0
url=https://github.com/ARMmbed/mbedtls/archive/v$v.tar.gz
sha256=d436ae4892bd80329ca18a3960052fbb42d3f1f46c7519711d6763621ca6cfa0

build() {
        gmake
        gmake DESTDIR="$DESTDIR" install
}
