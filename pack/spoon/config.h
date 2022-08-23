/* delay between each update in seconds */
int delay = 1;

struct ent ents[] = {
	/* reorder/edit/remove these as you see fit */
	{ .fmt = " %s",		.read = mixread,	.arg = NULL },
	{ .fmt = " | %s",	.read = loadread,	.arg = NULL },
	{ .fmt = " | %s",	.read = cpuread,	.arg = NULL },
	{ .fmt = " | %s°",	.read = tempread,	.arg = NULL },
#ifdef __OpenBSD__
	{ .fmt = " | %s",	.read = battread,	.arg = NULL },
#endif
#ifdef __linux__
	{ .fmt = " | %s",	.read = battread,	.arg = &(struct battarg){ .cap = "/sys/class/power_supply/BAT0/capacity", .ac = "/sys/class/power_supply/AC/online" } },
	{ .fmt = " %s",		.read = battread,	.arg = &(struct battarg){ .cap = "/sys/class/power_supply/BAT1/capacity", .ac = "/sys/class/power_supply/AC/online" } },
#endif

	{ .fmt = " | %s",	.read = wifiread,	.arg = NULL },
	{ .fmt = " | %s ",	.read = dateread,	.arg = &(struct datearg){ .fmt = "%a %b %d %H:%M:%S", .tz = NULL } },
};
