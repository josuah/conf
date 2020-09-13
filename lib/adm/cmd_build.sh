
_build_git() {
	local bare="$cache/git/$name"
	export src="$cache/src/$name-$commit"

	if [ ! -d "$bare" ]; then
		git clone --mirror "$url" "$bare"
	fi

	if [ ! -d "$DESTDIR" ]; then
		git -C "$bare" rev-parse "$commit" >/dev/null ||
			git -C "$bare" fetch
		git -C "$bare" rev-parse "$commit" >/dev/null
		mkdir -p "$src"
		git -C "$bare" archive "$commit" | tar -C "$src" -xf -
	fi
}

_build_tar() {
	local tar="$cache/tar/$name-$(basename "$url")"
	export src="$cache/src/$name-$v"

	if [ ! -f "$tar" ]; then
		mkdir -p "$(dirname "$tar")"
		curl -Ls -o "$tar" "$url"
	fi

	if [ ! -d "$DESTDIR" ]; then
		openssl sha256 "$tar" \
		| sed 's/.* //' | tee /dev/stderr | grep -Fqx "$sha256" || {
			echo >&2 invalid checksum
			exit 1
		}

		mkdir -p "$tmp/build/src" "$src"
		case $tar in
		(*gz) gzip -cd "$tar" ;;
		(*xz) xz -cd "$tar" ;;
		(*lz) lz -cd "$tar" ;;
		esac | tar -x -f - -C "$tmp/build/src"
		rm -rf "$src"
		mv "$tmp/build/src/"* "$src"
	fi
}

cmd_build_install() { set -eu
	local name="$1"
	local opt

	. "$etc/build/$name/build.sh"

	export PREFIX="$usr"
	export DESTDIR="$PREFIX/opt/${sha256:-$commit}"
	export opt="$PREFIX/opt/$name-${v:-$commit}"

	[ -d "$opt" ] && return 0
	[ "${sha256:-}" ] && _build_tar
	[ "${commit:-}" ] && _build_git

	if [ -d "$etc/build/$name/files" ]; then
		cp -r "$etc/build/$name/files/"* "$src"
	fi

	if [ -d "$etc/build/$name/patches" ]; then
		for x in "$etc/build/$name/patches/"*; do
			(cd "$src"; patch -p1 -N) <$x
		done
	fi

	mkdir -p "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	ln -sf "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	(cd "$src"; build) || exit "$?"

	rm -rf "$DESTDIR/$PREFIX" "$src"
	! rmdir "$DESTDIR/"* 2>/dev/null

	mv "$DESTDIR" "$opt"
	cd "$opt"
	find *	-type d -exec mkdir -p "$PREFIX/{}" \; -o \
		-type f -exec ln -sf "$PWD/{}" "$PREFIX/{}" \;
}
