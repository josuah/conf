#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <grp.h>
#include <limits.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
#include <sys/stat.h>

/*
 * Common code included from various single-c-file projects on this directory.
 */

#ifndef __OpenBSD__
#define pledge(...) 0
#define unveil(...) 0
#endif

#ifndef PATH_MAX
#define PATH_MAX 256
#endif

char *arg0;

static void
_log(char const *fmt, va_list va, int err)
{
	if (arg0 != NULL)
		fprintf(stderr, "%s: ", arg0);
	vfprintf(stderr, fmt, va);
	fprintf(stderr, err ? ": %s\n" : "\n", strerror(err));
	fflush(stderr);
}

void
err(int e, char const *fmt, ...)
{
	va_list va;

	va_start(va, fmt);
	_log( fmt, va, errno);
	exit(e);
}

void
errx(int e, char const *fmt, ...)
{
	va_list va;

	va_start(va, fmt);
	_log( fmt, va, 0);
	exit(e);
}

void
warn(char const *fmt, ...)
{
	va_list va;

	va_start(va, fmt);
	_log(fmt, va, errno);
}

void
warnx(char const *fmt, ...)
{
	va_list va;

	va_start(va, fmt);
	_log(fmt, va, 0);
}

size_t
strlcpy(char *d, char const *s, size_t sz)
{
	size_t len, cpy;

	len = strlen(s);
	cpy = (len > sz) ? (sz) : (len);
	memcpy(d, s, cpy + 1);
	d[sz - 1] = '\0';
	return len;
}

size_t
strlcat(char *d, char const *s, size_t dsz)
{
	size_t dlen;

	dlen = strlen(d);
	if (dlen >= dsz)
		return dlen + strlen(s);
	return dlen + strlcpy(d + dlen, s, dsz - dlen);
}

char *
strsep(char **sp, char const *sep)
{
	char *s, *prev;

	if (*sp == NULL)
		return NULL;
	prev = *sp;
	for (s = *sp; strchr(sep, *s) == NULL; s++);
	if (*s == '\0') {
		*sp = NULL;
	} else {
		*sp = s + 1;
		*s = '\0';
	}
	return prev;
}

void
strchomp(char *line)
{
	size_t len;

	len = strlen(line);
	if (len > 0 && line[len - 1] == '\n')
		line[--len] = '\0';
	if (len > 0 && line[len - 1] == '\r')
		line[--len] = '\0';
}

char *
strappend(char **dp, char const *s)
{
	size_t dlen, slen;
	void *mem;

	dlen = (*dp == NULL) ? 0 : strlen(*dp);
	slen = strlen(s);
	if ((mem = realloc(*dp, dlen + slen + 1)) == NULL)
		return NULL;
	*dp = mem;
	memcpy(*dp + dlen, s, slen + 1);
	return *dp;
}

size_t
strsplit(char *s, char **array, size_t len, char const *sep)
{
	size_t i;

	assert(len > 0);
	for (i = 0; i < len; i++)
		if ((array[i] = strsep(&s, sep)) == NULL)
			break;
	array[len - 1] = NULL;
	return i;
}

time_t
tztime(struct tm *tm, char const *tz)
{
	char *env, old[32];
	time_t t;

	env = getenv("TZ");
	if (strlcpy(old, env ? env : "", sizeof old) >= sizeof old)
		return -1;
	if (setenv("TZ", tz, 1) < 0)
		return -1;

	tzset();
	t = mktime(tm);

	if (env == NULL)
		unsetenv("TZ");
	else if (setenv("TZ", old, 1) < 0)
		return -1;
	return t;
}

void *
reallocarray(void *mem, size_t n, size_t sz)
{
	if (SIZE_MAX / n < sz)
		return errno=ERANGE, NULL;
	return realloc(mem, n * sz);
}

uint64_t
strint(char **sp, uint64_t max, uint8_t b)
{
	uint64_t n;
	char *s, *p, *digits = "0123456789ABCDEF";
	char c;

	n = 0;
	for (s = *sp ;; s++) {
		c = toupper(*s);
		p = strchr(digits, c);
		if (p == NULL || p >= digits + b)
			break;

		if (n > max / b)
			goto err;
		n *= b;

		if (n > max - (p - digits))
			goto err;
		n += p - digits;
	}
	if (*sp == s)
		goto err;
	*sp = s;
	return n;
err:
	*sp = NULL;
	return 0;
}

int
getgrouplist(const char *name, gid_t basegid, gid_t *groups, int *ngroups)
{
	struct group *gr;
	int i;

	assert(*ngroups > 0);
	errno = 0;
	setgrent();
	groups[0] = basegid;
	for (i = 1; (gr = getgrent()) != NULL; i++) {
		if (i == *ngroups) {
			errno = EFBIG;
			goto err;
		}
		for (char **mem = gr->gr_mem; *mem != NULL; mem++)
			if (strcmp(*mem, name) == 0)
				groups[i] = gr->gr_gid;
	}
	*ngroups = i;
err:
	endgrent();
	return errno ? -1 : 0;
}

static inline void
xstat(char *path, struct stat *st)
{
	if (stat(path, st) == -1)
		err(1, "reading %s status", path);
}

static inline void
xstrlcpy(char *dst, char const *src, size_t sz)
{
	if (strlcpy(dst, src, sz) >= sz)
		err(1, "string too long: %s", src);
}

static inline void
xstrlcat(char *dst, char *src, size_t sz)
{
	if (strlcat(dst, src, sz) >= sz)
		err(1, "string too long: %s", dst);
}

static inline void
xrename(char const *from, char const *to)
{
	if (rename(from, to) == -1)
		err(1, "cannot rename %s to %s", from, to);
}

static inline DIR *
xopendir(char const *path)
{
	DIR *dp;

	if ((dp = opendir(path)) == NULL)
		err(1, "cannot open directory %s", path);
	return dp;
}
