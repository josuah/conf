
cmd_exec_start() { set -eu
	local flags="$name${flags:+ $flags}"
	local pexp="${pexp:-$flags}"

	send "pgrep -f '$pexp' >/dev/null || $name $flags 2>&1 | logger -t $name"
	cmd_exec_status "$name"
}

cmd_exec_stop() { set -eu
	local flags="$name${flags:+ $flags}"
	local pexp="${pexp:-$flags}"

	send "pkill -f '$pexp'"
}

cmd_exec_status() { set -eu
	local flags="$name${flags:+ $flags}"
	local pexp="${pexp:-$flags}"

	send "pgrep -f '$pexp'"
}

cmd_exec_reload() { set -eu
	local flags="$name${flags:+ $flags}"
	local pexp="${pexp:-$flags}"

	send "pkill -f -HUP '$pexp'"
}

cmd_exec_restart() { set -eu
	cmd_exec_stop "$name"
	cmd_exec_start "$name"
}
