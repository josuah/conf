#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
#include "util.h"

/*
 * converter for Intel HEX to plain binary output.
 * https://en.wikipedia.org/wiki/Intel_HEX
 */

enum type {
	TYPE_DATA = 0x00, TYPE_END_OF_FILE = 0x01,
	TYPE_EXTENDED_SEGMENT_ADDR = 0x02, TYPE_START_SEGMENT_ADDR = 0x03,
	TYPE_EXTENDED_LINEAR_ADDR = 0x04, TYPE_START_LINEAR_ADDR = 0x05,
};

enum pos {
	POS_LENGTH = 0, POS_ADDR = 1, POS_TYPE = 3, POS_DATA = 4,
};

typedef struct {
	char *buf, *err;
	size_t hexsz, binsz;
	uint32_t baseaddr;
	uint16_t addr;
	enum type type;
	FILE *fp;
} Hex;

static int
hex_error(Hex *h, char *msg)
{
	h->err = msg;
	return -1;
}

/*
 * override h->buf that contains hex string with decoded binary data
 */
static int
hex_buf2bin(Hex *h)
{
	size_t len;
	uint8_t *buf, cksum=0;

	len = strlen(h->buf);
	if (len < strlen(":00000001FF") || len % 2 != 1)
		return hex_error(h, "invalid line length");

	buf = (uint8_t *)h->buf;
	if (buf[0] != ':')
		return hex_error(h, "missing leading ':'");

	h->binsz = 0;
	for (uint8_t *s = buf+1, *d = buf; s[0] && s[1]; s += 2, d += 1) {
		char c0 = tolower(s[0]), c1 = tolower(s[1]);

		if (!isxdigit(c0) || !isxdigit(c1))
			return hex_error(h, "invalid hex string");

#define X(c) ((c) >= 'a' ? (c) - 'a' + 10 : (c) - '0')
		*d = (X(c0) << 4) | X(c1);
#undef X
		cksum += *d;
		h->binsz++;
	}
	h->binsz -= POS_DATA;
	h->binsz -= 1; /* checksum */

	if (cksum != 0)
		return hex_error(h, "invalid checksum");
	if (h->binsz != buf[POS_LENGTH])
		return hex_error(h, "invalid length");

	return 0;
}

/*
 * The sizes are expressed as decoded byte length rather than hex
 * digit count. The encoded string looks like:
 *	":SSAAAATTDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDCC"
 * With S=size, A=addr, T=type, D=data, C=checksum.
 */
static int
hex_getline(Hex *h)
{
	uint8_t *buf;

	do {
		if (getline(&h->buf, &h->hexsz, h->fp) <= 0)
			return -1;
		strchomp(h->buf);
	} while (h->buf[0] == '\0');

	if (hex_buf2bin(h) < 0)
		return -1;

	buf = (uint8_t *)h->buf;

	switch (h->type = buf[POS_TYPE]) {
	case TYPE_DATA:
		h->addr = (buf[POS_ADDR] << 8) | buf[POS_ADDR+1];
		break;
	case TYPE_END_OF_FILE:
		return 0;
	case TYPE_EXTENDED_SEGMENT_ADDR:
		if (buf[POS_LENGTH] != 2)
			return hex_error(h,
			    "Extended Segment Address is not 2 bytes long");
		h->baseaddr = (buf[POS_DATA] << 8) | buf[POS_DATA+1];
		break;
	case TYPE_START_SEGMENT_ADDR:
		warn("Start Segment Address is not supported");
		break;
	case TYPE_EXTENDED_LINEAR_ADDR:
		if (buf[POS_LENGTH] != 2)
			return hex_error(h,
			    "Extended Linear Address is not 2 bytes long");
		h->baseaddr = (buf[POS_DATA] << 24) | (buf[POS_DATA+1] << 16);
		break;
	case TYPE_START_LINEAR_ADDR:
		warn("Start Segment Address is not supported");
	}
	return 1;
}

static int
hex_write(Hex *h)
{
	ssize_t w;
	size_t o, n;
	char *s;

	if (h->type != TYPE_DATA)
		return 0;
	s = h->buf + POS_DATA;
	o = h->baseaddr + h->addr;
	n = h->binsz;
	do {
		if ((w = pwrite(1, s, n, o)) < 0)
			return hex_error(h, strerror(errno));
		s += w;
		o += w;
		n -= w;
	} while (n > 0);
	return 0;
}

static int
hex_init(Hex *h, char *path)
{
	memset(h, 0, sizeof *h);

	if (path == NULL)
		h->fp = stdin;
	else if ((h->fp = fopen(path, "r")) == NULL)
		return hex_error(h, strerror(errno));

	return 0;
}

static void
hex_free(Hex *h)
{
	if (h->fp)
		fclose(h->fp);
	free(h->buf);
	memset(h, 0, sizeof *h);
}

static void
usage(void)
{
	fprintf(stderr, "usage: %s [file.hex] >file.bin\n", arg0);
	exit(1);
}

int
main(int argc, char **argv)
{
	Hex h = {0};
	size_t lnum;

	if (pledge("stdio rpath", NULL) < 0)
		err(1, "pledge");

	arg0 = *argv++, argc--;

	if (argc > 1)
		usage();
	if (pwrite(1, NULL, 0, 0) < 0)
		err(1, "expecting seekable file on stdout: %s",
		    strerror(errno));
	if (hex_init(&h, *argv) < 0)
		err(1, "%s: %s", *argv, h.err);

	if (pledge("stdio", NULL) < 0)
		err(1, "pledge");

	for (lnum = 1; hex_getline(&h) >= 0; lnum++)
		if (hex_write(&h) < 0)
			err(1, "%s:0x%z08X: %s", *argv, lnum, h.err);
	if (h.err)
		err(1, "%s:%d: %s", *argv, lnum, h.err);
	if (ferror(h.fp) || ferror(stdout))
		err(1, "%s: %s", *argv, strerror(errno));
	hex_free(&h);

	return 0;
}
