#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <strings.h>
#include <errno.h>
#include "util.h"

/*
 * converter for Intel HEX to plain binary output
 */

static void
hex2bin(FILE *fp, char *path)
{
	char *ln = NULL;
	size_t sz = 0;

	

	while (getline(&ln, &sz, fp) > 0) {
		strchomp(ln);
	}
}

void
usage(void)
{
	fprintf(stderr, "usage: %s file...\n", arg0);
	exit(1);
}

int
main(int argc, char **argv)
{
	(void)argc;

	arg0 = *argv;
	argv++;

	if (pledge("stdio rpath wpath", NULL) < 0)
		err(1, "pledge");

	if (*argv == NULL)
		usage();

	for (FILE *fp; *argv != NULL; argv++) {
		if (strcasestr(".hex", ))

		if ((fp = fopen(*argv, "r")) == NULL)
			err(1, "%s: %s", *argv, strerror(errno));
		hex2bin(fp);
		fclose(fp);
	}

	return 0;
}
