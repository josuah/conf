
cmd_exec_start() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	pgrep -f "$pexp" && return
	$argv 2>&1 | logger -t "$cmd" &
	cmd_exec_status "$cmd"
}

cmd_exec_stop() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	pkill -f "$pexp"
}

cmd_exec_status() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	pgrep -f "$pexp"
}

cmd_exec_restart() { set -eu
	cmd_exec_stop "$1"
	cmd_exec_start "$1"
}
