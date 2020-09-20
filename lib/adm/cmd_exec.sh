
cmd_exec_start() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	pgrep -f "$pexp" >/dev/null && return

	if [ "${var_listen:-}" ]; then
		export LISTEN_FDS=1

		s6-tcpserver4-socketbinder 0.0.0.0 "$var_port" \
		  sh -c "exec $argv 3>&0" 2>&1 \
		| logger -t "$cmd" &

		s6-tcpserver6-socketbinder :: "$var_port" \
		  sh -c "exec $argv 3>&0" 2>&1 \
		| logger -t "$cmd" &
	else
		sh -c "exec $argv" 2>&1 | logger -t "$cmd"
	fi

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

cmd_exec_reload() { set -eu
	local cmd="$1"
	local argv="$cmd${var_argv:+ $var_argv}"
	local pexp="${var_pexp:-$argv}"

	pkill -f -HUP "$pexp"
}

cmd_exec_restart() { set -eu
	cmd_exec_stop "$1"
	cmd_exec_start "$1"
}
