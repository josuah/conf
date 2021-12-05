 #!/bin/sh -eu
# host a file onto my server through scp

usage() {
	echo "usage: ${0##*} [-p prefix] file" >&2
	exit 1
}

domain=josuah.net
prefix=p

while [ $# -gt 0 ]; do
	case $1 in
	(-p) shift; prefix=$1 ;;
	(-*) usage ;;
	(--) shift; break ;;
	(*) break ;;
	esac
	shift
done

for file in "$@"; do
	name=$prefix/$(basename "$file")
	type=$(tr '%\0' '.%' <$file | grep -q % && echo 9 || echo 0)
	scp "$file" "$domain:/var/www/htdocs/default/$name"
	echo "gopher://$domain/$type/$name"
	echo "https://$domain/$name"
done
