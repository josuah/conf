
_pkg_git() { set -eu
	local bare="$cache/git/$name"

	if [ ! -d "$bare" ]; then
		git clone --mirror "$url" "$bare"
	fi

	if ! send "test -d '$DESTDIR'"; then
		git -C "$bare" rev-parse "$commit" >/dev/null ||
			git -C "$bare" fetch
		rm -rf "$SOURCE"
		mkdir -p "$SOURCE"
		git -C "$bare" archive "$commit" | send "
			tar -C "$SOURCE" -xf -
		"
	fi
}

_pkg_tar() { set -eu
	local tar="$cache/tar/$(basename "$url")"

	if [ ! -f "$tar" ]; then
		mkdir -p "$(dirname "$tar")"
		curl -Ls -o "$tar" "$url"
	fi

	if ! send "test -d '$DESTDIR'"; then
		openssl sha256 "$tar" \
		| sed 's/.* //' | tee /dev/stderr | grep -Fqx "$sha256" || {
			echo >&2 invalid checksum
			exit 1
		}

		case $tar in
		(*gz) gzip -cd "$tar" ;;
		(*xz) xz -cd "$tar" ;;
		(*lz) lz -cd "$tar" ;;
		esac | send "
			mkdir -p '$SOURCE.tmp.$$' '$SOURCE'
			rm -rf '$SOURCE'
			tar -x -f - -C '$SOURCE.tmp.$$'
			mv '$SOURCE.tmp.$$/'* '$SOURCE'
		"
	fi
}

cmd_pkg_install() { set -eu
	local name="$1"

	[ -f "$etc/pkg/$name/lib.sh" ] || return

	. "$etc/pkg/$name/lib.sh"

	export PREFIX="$usr"
	export DESTDIR="$PREFIX/opt/$name-${v:-$commit}"
	export SOURCE="$cache/src/$name-${v:-$commit}"

	[ -d "$DESTDIR" ] && return 0
	[ "${sha256:-}" ] && _pkg_tar
	[ "${commit:-}" ] && _pkg_git

	if [ -d "$etc/pkg/$name/files" ]; then
		scp -r "$etc/pkg/$name/files/"* "$host:$SOURCE"
	fi

	if [ -d "$etc/pkg/$name/patches" ]; then
		cat "$etc/pkg/$name/patches/"* | send "
			cd '$SOURCE'
			patch -p1 -N
		"
	fi

	send "
		mkdir -p '$DESTDIR/bin' '$DESTDIR/sbin' '$DESTDIR/lib' \
		  '$DESTDIR/libexec' '$DESTDIR/include' '$DESTDIR$PREFIX'

		ln -sf '$DESTDIR/bin' '$DESTDIR/sbin' '$DESTDIR/lib' \
		  '$DESTDIR/libexec' '$DESTDIR/include' '$DESTDIR$PREFIX'

		cd '$SOURCE'
		sh -eux

		rm -rf '$DESTDIR/$PREFIX' '$SOURCE'
		! rmdir '$DESTDIR/'* 2>/dev/null

		cd '$DESTDIR'
		find *	-type d -exec mkdir -p '$PREFIX/{}' \; -o \
			-type f -exec ln -sf '$PWD/{}' '$PREFIX/{}' \;

	" <$etc/pkg/$name/build.sh
}
