
_build_git() {
	local bare="$cache/git/$name"
	export source="$cache/source/$name-$commit"

	[ -d "$bare" ] && exit 0
	git clone --mirror "$url" "$bare"

	[ -d "$source" ] && exit 0
	git -C "$bare" rev-parse "$commit" >/dev/null || git -C "$bare" fetch
	git -C "$bare" rev-parse "$commit" >/dev/null || exit 1
	mkdir -p "$source"
	git -C "$bare" archive "$commit" | tar -C "$source" -xf -
}

_build_tar() {
	local archive="$cache/archive/$name-$(basename "$url")"
	export source=$cache/source/$name-$v

	mkdir -p "$(dirname "$archive")"
	curl -Ls -o "$archive" "$url"

	openssl sha256 "$archive" \
	| sed 's/.* //' | tee /dev/stderr | grep -Fqx "$sha256" || {
		echo >&2 invalid checksum
		exit 1
	}

	tmp=$(mktemp -d)
	trap_add 'rm -rf "$tmp"'

	case $archive in
	(*gz) gzip -cd "$archive" ;;
	(*xz) xz -cd "$archive" ;;
	(*lz) lz -cd "$archive" ;;
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

	export PREFIX="$usr"
	export DESTDIR="$PREFIX/opt/$name-${v:-$commit}"

	[ -d "$DESTDIR" ] && return 0

	trap_add 'rm -rf "$DESTDIR"'

	mkdir -p "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	ln -sf "$DESTDIR/bin" "$DESTDIR/sbin" "$DESTDIR/lib" \
	  "$DESTDIR/libexec" "$DESTDIR/include" "$DESTDIR$PREFIX"

	build

	rm -rf "$DESTDIR/usr" "$source"

	trap_pop

	cd "$DESTDIR"
	find *	-type d -exec mkdir -p "$PWD/{}" \; -o \
		-type f -exec ln -sf "$PWD/{}" "$PREFIX/{}" \;
}
