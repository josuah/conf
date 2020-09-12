
cmd_service_enable() {
	echo "$1=YES" >"/etc/rc.conf.d/$1"
}

cmd_service_disable() {
	rm "/etc/rc.conf.d/$1"
}

cmd_service_start() {
	"/etc/rc.d/$1" start
}

cmd_service_stop() {
	"/etc/rc.d/$1" stop
}

cmd_service_restart() {
	"/etc/rc.d/$1" restart
}

cmd_service_reload() {
	"/etc/rc.d/$1" reload
}

cmd_service_status() {
	"/etc/rc.d/$1" status
}
