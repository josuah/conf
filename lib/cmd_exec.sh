
cmd_exec_start() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	send "pgrep -f '$pexp' >/dev/null || $cmd $argv 2>&1 | logger -t $cmd"
	cmd_exec_status "$1"
}

cmd_exec_stop() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	send "pkill -f '$pexp'"
}

cmd_exec_status() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	send "pgrep -f '$pexp'"
}

cmd_exec_reload() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	send 'pkill -f -HUP '$pexp'"
}

cmd_exec_restart() { set -eu
	cmd_exec_stop "$1"
	cmd_exec_start "$1"
}
