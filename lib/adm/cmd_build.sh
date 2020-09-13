
_build_git() {
	local bare="$cache/git/$name"
	export source="$cache/src/$name-$commit"

	if [ ! -d "$bare" ]; then
		git clone --mirror "$url" "$bare"
	fi

	if [ ! -d "$DESTDIR" ]; then
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

	if [ ! -d "$DESTDIR" ]; then
		openssl sha256 "$tar" \
		| sed 's/.* //' | tee /dev/stderr | grep -Fqx "$sha256" || {
			echo >&2 invalid checksum
			exit 1
		}

		mkdir -p "$tmp/build/source"
		case $tar in
		(*gz) gzip -cd "$tar" ;;
		(*xz) xz -cd "$tar" ;;
		(*lz) lz -cd "$tar" ;;
		esac | tar -x -f - -C "$tmp/build/source"
		mkdir -p "$tmp" "$(dirname "$source")"
		rm -rf "$source"
		mv "$tmp/"* "$source"
	fi
}

cmd_build_install() {
	local name="$1"
	local opt

	set -e

	. "$etc/build/$name/build.sh"

	export PREFIX="$usr"
	export DESTDIR="$PREFIX/opt/${sha256:-$commit}"
	export opt="$PREFIX/opt/$name-${v:-$commit}"

	[ -d "$opt" ] && return 0
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

	mkdir -p "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	ln -sf "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	(cd "$source"; build) || exit "$?"

	rm -rf "$DESTDIR/$PREFIX" "$source"
	! rmdir "$DESTDIR/"* 2>/dev/null

	mv "$DESTDIR" "$opt"
	cd "$opt"
	find *	-type d -exec mkdir -p "$PREFIX/{}" \; -o \
		-type f -exec ln -sf "$PWD/{}" "$PREFIX/{}" \;
}
