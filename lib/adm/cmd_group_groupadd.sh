
cmd_group_install() {
	awk -F : -v g="$1" '$1==g {n++} END {exit(!n)}' /etc/group && return 0
	groupadd "$1"
}
