/* nextvi configuration file */
#include "kmap.h"

/* access mode of new files */
#define MKFILE_MODE		0600

struct filetype fts[] = {
	{"msg", "letter$|mbox$|mail$"},			/* email */
	{"diff", "\\.(patch|diff)$"},			/* diff */
	{"text", ".*"},					/* any text */
};
int ftslen = LEN(fts);

/*
colors 0-15
0 = black | inverse
1 = red3
2 = green3
3 = yellow3
4 = blue2
5 = magenta3
6 = cyan3
7 = gray90
bright colors
8 = gray50
9 = red
10 = green
11 = yellow
12 = blue
13 = magenta
14 = cyan
15 = white
*/

struct highlight hls[] = {
	/* lbuf lines are *always "\n\0" terminated, for $ to work one needs to account for '\n' too */
	/* "/" is default hl, must have at least 1 entry for fallback */
	{"/", NULL, {14 | SYN_BD}, {1}, 0, 2},  /* <-- optional, used by hll if set */
	/* optional, used by hlp if set */
	{"/", NULL, {0, 9 | SYN_BGMK(10), 9 | SYN_BGMK(10)}, {1, -1, -1}, 0, 3},
	{"/", NULL, {9}, {0}, 0, 1}, /* <-- optional, used by hlw if set */

	/* text */
	{"text", "^\t{10}(.+)", {7, 6}},
	{"text", "^\t{09}[^\t]{08}(.+)", {7, 6}},
	{"text", "^\t{08}[^\t]{16}(.+)", {7, 6}},
	{"text", "^\t{07}[^\t]{24}(.+)", {7, 6}},
	{"text", "^\t{06}[^\t]{32}(.+)", {7, 6}},
	{"text", "^\t{05}[^\t]{40}(.+)", {7, 6}},
	{"text", "^\t{04}[^\t]{48}(.+)", {7, 6}},
	{"text", "^\t{03}[^\t]{56}(.+)", {7, 6}},
	{"text", "^\t{02}[^\t]{64}(.+)", {7, 6}},
	{"text", "^\t{01}[^\t]{72}(.+)", {7, 6}},
	{"text", "^[^\t]{80}(.+)", {7, 6}},

	/* mail */
	{"msg", NULL, {14 | SYN_BD}, {1}, 0, 2},
	{"msg", NULL, {9}, {0}, 0, 1},
	{"msg", "^From .*20..\n$", {6 | SYN_BD}},
	{"msg", "^Subject: (.*)", {6 | SYN_BD, 4 | SYN_BD}},
	{"msg", "^From: (.*)", {6 | SYN_BD, 2 | SYN_BD}},
	{"msg", "^To: (.*)", {6 | SYN_BD, 5 | SYN_BD}},
	{"msg", "^Cc: (.*)", {6 | SYN_BD, 5 | SYN_BD}},
	{"msg", "^[-A-Za-z]+: .+", {6 | SYN_BD}},
	{"msg", "^> .*", {2 | SYN_IT}},

	/* diff */
	{"diff", "^-.*", {1}},
	{"diff", "^\\+.*", {2}},
	{"diff", "^@.*", {6}},
	{"diff", "^diff .*", {SYN_BD}},

	/* file manager */
	{"/fm", "^\\.+(?:(?:(/)\\.\\.+)+)?", {4, 6}},
	{"/fm", "[^/]*\\.sh\n$", {2}},
	{"/fm", "[^/]*(?:\\.c|\\.h|\\.cpp|\\.cc)\n$", {5}},
	{"/fm", "/.+/([^/]+\n$)?", {6, 8}, {1, 1}},
	{"/fm", "(/).+[^/]+\n$", {8, 6}, {1, 1}},

	/* numbers highlight for ^v */
	{"/#", "[ewEW]", {14 | SYN_BD}},
	{"/#", "1([ \t]*[1-9][ \t]*)9", {9, 13 | SYN_BD}},
	{"/#", "9[ \t]*([1-9][ \t]*)1", {9, 13 | SYN_BD}},
	{"/#", "[1-9]", {9}},

	/* autocomplete dropdown */
	{"/ac", "[^ \t-/:-@[-^{-~]+(?:(\n$)|\n)|\n|([^\n]+(\n))",
		{0, SYN_BGMK(9), SYN_BGMK(8), SYN_BGMK(7)}},
	{"/ac", "[^ \t-/:-@[-^{-~]+$|(.+$)", {0, SYN_BGMK(8)}},

	/* status bar (is never '\n' terminated) */
	{"/-", "^(\".*\").*(\\[[wr]\\]).*$", {8 | SYN_BD, 4, 1}},
	{"/-", "^(\".*\").* ([0-9]{1,3}%) (L[0-9]+) (C[0-9]+) (B[0-9]+)?.*$",
		{8 | SYN_BD, 4, 9, 4, 11, 2}},
	{"/-", "^.*$", {8 | SYN_BD}},
};
int hlslen = LEN(hls);

/* how to highlight text in the reverse direction */
#define SYN_REVDIR		SYN_BGMK(8)

/* right-to-left characters (used only in dctxs[] and dmarks[]) */
#define CR2L		"ءآأؤإئابةتثجحخدذرزسشصضطظعغـفقكلمنهوىييپچژکگی‌‍؛،»«؟ًٌٍَُِّْ"
/* neutral characters (used only in dctxs[] and dmarks[]) */
#define CNEUT		"-!\"#$%&'\\()*+,./:;<=>?@^_`{|}~ "

struct dircontext dctxs[] = {
	{-1, "^[" CR2L "]"},
	{+1, "^[a-zA-Z_0-9]"},
};
int dctxlen = LEN(dctxs);

struct dirmark dmarks[] = {
	{+0, +1, 1, "\\\\\\*\\[([^\\]]+)\\]"},
	{+1, -1, 0, "[" CR2L "][" CNEUT CR2L "]*[" CR2L "]"},
	{-1, +1, 0, "[a-zA-Z0-9_][^" CR2L "\\\\`$']*[a-zA-Z0-9_]"},
	{+0, +1, 0, "\\$([^$]+)\\$"},
	{+0, +1, 1, "\\\\[a-zA-Z0-9_]+\\{([^}]+)\\}"},
	{-1, +1, 0, "\\\\[^ \t" CR2L "]+"},
};
int dmarkslen = LEN(dmarks);

struct placeholder placeholders[] = {
	{0x200c, "-", 1}, /* ‌ */
	{0x200d, "-", 1}, /* ‍ */
};
int placeholderslen = LEN(placeholders);

int conf_hlrev(void)
{
	return SYN_REVDIR;
}

int conf_mode(void)
{
	return MKFILE_MODE;
}

char **conf_kmap(int id)
{
	return kmaps[id];
}

int conf_kmapfind(char *name)
{
	for (int i = 0; i < LEN(kmaps); i++)
		if (name && kmaps[i][0] && !strcmp(name, kmaps[i][0]))
			return i;
	return 0;
}

char *conf_digraph(int c1, int c2)
{
	for (int i = 0; i < LEN(digraphs); i++)
		if (digraphs[i][0][0] == c1 && digraphs[i][0][1] == c2)
			return digraphs[i][1];
	return NULL;
}
