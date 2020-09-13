
cmd_group_install() { set -eu
	awk -F : -v g="$1" '$1==g {n++} END {exit(!n)}' /etc/group && return 0
	pw groupadd "$1"
}
