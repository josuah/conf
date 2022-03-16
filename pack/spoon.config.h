/* delay between each update in seconds */
int delay = 1;

struct ent ents[] = {
	/* reorder/edit/remove these as you see fit */
	{ .fmt = " %s",		.read = mixread,	.arg = NULL },
	{ .fmt = " | %s",	.read = loadread,	.arg = NULL },
	{ .fmt = " | %s",	.read = cpuread,	.arg = NULL },
	{ .fmt = " | %s°",	.read = tempread,	.arg = NULL },
	{ .fmt = " | %s",	.read = battread,	.arg = NULL },
	{ .fmt = " | %s",	.read = wifiread,	.arg = NULL },
	{ .fmt = " | %s ",	.read = dateread,	.arg = &(struct datearg){ .fmt = "%a %b %d %H:%M:%S", .tz = NULL } },
};
