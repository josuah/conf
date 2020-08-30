
_build_git() {
	local bare="$cache/git/$name"
	export source="$cache/src/$name-$commit"

	if [ ! -d "$bare" ]; then
		git clone --mirror "$url" "$bare"
	fi

	if [ ! -d "$source" ]; then
		git -C "$bare" rev-parse "$commit" >/dev/null ||
			git -C "$bare" fetch
		git -C "$bare" rev-parse "$commit" >/dev/null
		mkdir -p "$source"
		git -C "$bare" archive "$commit" | tar -C "$source" -xf -
	fi
}

_build_tar() {
	local tar="$cache/tar/$name-$(basename "$url")"
	export source=$cache/src/$name-$v

	if [ ! -f "$tar" ]; then
		mkdir -p "$(dirname "$tar")"
		curl -Ls -o "$tar" "$url"
	fi

	openssl sha256 "$tar" \
	| sed 's/.* //' | tee /dev/stderr | grep -Fqx "$sha256" || {
		echo >&2 invalid checksum
		exit 1
	}

	tmp=$(mktemp -d)
	trap_add 'rm -rf "$tmp"'

	case $tar in
	(*gz) gzip -cd "$tar" ;;
	(*xz) xz -cd "$tar" ;;
	(*lz) lz -cd "$tar" ;;
	esac | tar -x -f - -C "$tmp"
	mkdir -p "$tmp" "$(dirname "$source")"
	rm -rf "$source"
	mv "$tmp/"* "$source"
}

cmd_build_install() {
	local name="$1"

	. "$etc/build/$name/build.sh"

	[ "${sha256:-}" ] && _build_tar
	[ "${commit:-}" ] && _build_git

	if [ -d "$etc/build/$name/files" ]; then
		cp -r "$etc/build/$name/files/"* "$source"
	fi

	if [ -d "$etc/build/$name/patches" ]; then
		for x in "$etc/build/$name/patches/"*; do
			(cd "$source"; patch -p1 -N) <$x
		done
	fi

	export PREFIX="$usr"
	export DESTDIR="$PREFIX/opt/$name-${v:-$commit}"

	[ -d "$DESTDIR" ] && return 0

	trap_add 'rm -rf "$DESTDIR"'

	mkdir -p "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	ln -sf "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	(cd "$source"; build)

	rm -rf "$DESTDIR/$PREFIX" "$source"
	! rmdir "$DESTDIR/"* 2>/dev/null

	trap_pop

	cd "$DESTDIR"
	find *	-type d -exec mkdir -p "$PWD/{}" \; -o \
		-type f -exec ln -sf "$PWD/{}" "$PREFIX/{}" \;
}
