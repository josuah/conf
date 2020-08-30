
cmd_monitor_monitor() {
	local name="$1"
	shift 1

	var_timeout=5

	. "$lib/monitor_$name.sh" >&2 & pid=$!
	sleep "$var_timeout" && kill "$pid" 2>/dev/null &
	wait "$pid" && status=ok || status=err
	echo $status do=monitor name=$name "$@"
}
