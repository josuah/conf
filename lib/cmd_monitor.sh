
cmd_monitor_monitor() {
	var_timeout=5

	. "$etc/monitor/$name" >&2 & pid=$!
	sleep "$var_timeout" && kill "$pid" 2>/dev/null &
	wait "$pid" && status=ok || status=err
	echo $status do=monitor name=$name $all_vars
}
