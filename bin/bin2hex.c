#include <unistd.h>
#include <arpa/inet.h>
#include <assert.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "util.h"

/*
 * Converter from binary file to Intel HEX output.
 * https://en.wikipedia.org/wiki/Intel_HEX
 */

#define BUFSIZE 0x10

enum type {
	TYPE_DATA = 0, TYPE_END_OF_FILE = 1,
	TYPE_EXTENDED_SEGMENT_ADDR = 2, TYPE_START_SEGMENT_ADDR = 3,
	TYPE_EXTENDED_LINEAR_ADDR = 4, TYPE_START_LINEAR_ADDR = 5,
};

uint8_t zero[BUFSIZE];

uint32_t flag_baseaddr;
int	flag_skip;

static void
hex_bytes(uint8_t *buf, size_t sz, uint8_t *cksum)
{
	for (size_t i = 0; i < sz; i++) {
		printf("%02X", buf[i]);
		*cksum += buf[i];
	}
}

/*
 * The encoded string looks like:
 *	":SSAAAATTDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDCC"
 * With S=size, A=addr, T=type, D=data, C=checksum.
 */
static void
hex_print(uint8_t *buf, size_t sz, uint16_t addr, enum type type)
{
	uint8_t cksum=0;

	assert(sz < UINT16_MAX);

	addr = htons(addr);

	fputc(':', stdout);
	hex_bytes((uint8_t *)&sz, 1, &cksum);
	hex_bytes((uint8_t*)&addr, 2, &cksum);
	hex_bytes((uint8_t *)&type, 1, &cksum);
	hex_bytes(buf, sz, &cksum);

	cksum = 0x100 - cksum;
	printf("%02X\n", cksum);
}

static void
hex_data(uint16_t addr, uint8_t *buf, size_t sz)
{
	hex_print(buf, sz, addr, TYPE_DATA);
}

static void
hex_extended_addr(uint16_t upperbits)
{
	upperbits = htons(upperbits);
	hex_print((uint8_t *)&upperbits, sizeof upperbits, 0x0000,
	    TYPE_EXTENDED_LINEAR_ADDR);
}

static void
bin2hex(FILE *fp, uint32_t addr)
{
	ssize_t r;
	char buf[BUFSIZE];

	hex_extended_addr(addr >> 16);

	for (; (r = fread(buf, 1, sizeof buf, fp)) > 0; addr += r) {
		if (flag_skip && memcmp(buf, zero, sizeof buf) == 0)
			continue;
		flag_skip = 0;

		hex_data(addr, (uint8_t *)buf, r);

		if (addr > UINT32_MAX - r)
			err(1, "address overflow: 0x%04llx > 0x%04"PRIx32,
			    (long long)addr + r, UINT32_MAX);

		if ((uint16_t)addr > UINT16_MAX - r)
			hex_extended_addr((addr + r) >> 16);
	}
	if (ferror(fp))
		err(1, "fread: %s", strerror(errno));
	puts(":00000001FF");
}

static void
usage(void)
{
	fprintf(stderr, "usage: %s [-s] [-b baseaddr] [file.bin]\n", arg0);
	exit(0);
}

int
main(int argc, char **argv)
{
	char c;
	FILE *fp;

	if (pledge("stdio rpath wpath cpath", NULL) < 0)
		err(1, "pledge");

	arg0 = *argv;
	while ((c = getopt(argc, argv, "b:s")) != EOF) {
		char const *e = NULL;

		switch (c) {
		case 'b':
			flag_baseaddr = strtonum(optarg, 0, UINT32_MAX, &e);
			if (e != NULL)
				err(1, "baseaddr is %s", e);
			break;
		case 's':
			flag_skip = 1;
			break;
		default:
			usage();
		}
	}
	argv += optind;
	argc -= optind;

	if (argc > 1)
		usage();
	if (*argv == NULL || strcmp(*argv, "-") == 0)
		fp = stdin;
	else if ((fp = fopen(*argv, "r")) == NULL)
		err(1, "%s: %s", *argv, strerror(errno));

	if (pledge("stdio", NULL) < 0)
		err(1, "pledge");

	bin2hex(fp, flag_baseaddr);
	fclose(fp);

	return 0;
}
