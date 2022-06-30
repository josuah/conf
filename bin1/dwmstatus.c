#include <sys/time.h>
#include <sys/sensors.h>
#include <sys/sysctl.h>
#include <X11/Xlib.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include "util.h"

int
main(void)
{
	Display *dpy;
	char line[128] = {0};

	if ((dpy = XOpenDisplay(NULL)) == NULL)
		err(1, "cannot open display");

	while (1) {
		char datetime[32] = {0};
		time_t clock;
		double loadavg[3];

		clock = time(NULL);
		strftime(datetime, sizeof datetime, "%Y-%m-%d %H:%M:%S", localtime(&clock));

		if (getloadavg(loadavg, 1) == -1)
			warn("getloadavg");

		snprintf(line, sizeof line, " %.02f %s ", loadavg[0], datetime);

		XStoreName(dpy, DefaultRootWindow(dpy), line);
		XSync(dpy, False);

		sleep(1);
	}
}
