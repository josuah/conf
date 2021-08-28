#!/bin/sh -eu
# generate random strings

n=${2:-1}

bird=https://www.birds.cornell.edu/clementschecklist/wp-content/uploads/2019/08/eBird_Taxonomy_v2019.csv

case ${1:-help} in
(pass)
	openssl rand -base64 $((n * 48)) | tr '+/' 'az' | cut -c 1-20
	;;
(mac)
	openssl rand -hex $((n * 6)) \
	 | sed -r 's/(..)(..)(..)(..)(..)(..)/00:\2:\3:\4:\5:\6$/g' \
	 | tr -d '\n' | tr '$' '\n'
	;;
(ula)
	openssl rand -hex $((n * 6)) \
	 | sed -r 's/(....)(....)(....)/fd00:\1:\2:\3$/g' \
	 | tr -d '\n' | tr '$' '\n'
	;;
(suffix)
	openssl rand -hex $((n * 8)) \
	 | sed -r 's/(....)(....)(....)(....)/\1:\2:\3:\4$/g' \
	 | tr -d '\n' | tr '$' '\n'
	;;
(uuid)
	openssl rand -hex $((n * 16)) \
	 | sed -r 's/(.{8})(.{4})(.{4})(.{4})(.{12})/\1-\2-\3-\4-\5$/g' \
	 | tr -d '\n' | tr '$' '\n'
	;;
(bird)
	[ -f /var/tmp/bird.csv ] || curl "$bird" \
	 | awk -F "," '
		NR == 1 { for (f = 1; f <= NF && $f != "SCI_NAME"; f++); }
		NR > 1 { gsub(/[[(].*[])]/, ""); sub(".* ", "", $f) }
		length($f) > 3 && length($f) <= 6 && !F[$f]++ { print $f }
	' >/var/tmp/bird.csv
	awk -v r="$(openssl rand 2 | od -An -d)" -v n="$n" '
		BEGIN { srand(r) } { bird[NR] = $0 }
		END { while (n-- > 0) print bird[int(rand() * NR)] }
	' /var/tmp/bird.csv
	;;
(*)
	echo "usage:" >&1
	sed -rn "s/^\(([^*)]+).*/ ${0##*/} \1/p" "$0" >&1
	exit 1
	;;
esac
