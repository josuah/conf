/*
 * Bridging the BSD world and the DJB world:
 *
 * daemon(8) forks to background to daemonize (BSD) and invoke a
 * child to foreground (DJB).
 *
 * daemon(8) calls the child with stdout and stderr replaced by a
 * pipe, from which daemon(8) reads the logs (DJB) further sent to
 * syslog (BSD).
 */

#include <assert.h>
#include <sys/wait.h>
#include <syslog.h>
#include <unistd.h>
#include <signal.h>
#include <pwd.h>

#include "util.h"

char	*flag_user;
int	 flag_facility = LOG_DAEMON;
char	*flag_dir;
int	 flag_restart;
int	 flag_no_close;
pid_t	 child;

static void
logger(int fd)
{
	FILE *fp;
	char line[1024];

	if ((fp = fdopen(fd, "r")) == NULL) {
		syslog(LOG_ERR, "(daemon) fdopen pipe: %s", strerror(errno));
		exit(1);
	}

	for (size_t i = 0;;) {
		int c;

		if (i >= sizeof line - 1) {
			line[sizeof line - 1] = '\0';
			syslog(LOG_NOTICE, "%s \\", line);
			i = 0;
		}

		switch ((c = fgetc(fp))) {
		case EOF:
			if (ferror(fp))
				syslog(LOG_ERR, "(daemon) reading logs: %s",
				    strerror(errno));
			fclose(fp);
			return;
		case '\r':
		case '\n':
			line[i] = '\0';
			syslog(LOG_NOTICE, "%s", line);
			i = 0;
			break;
		default:
			line[i++] = c;
		}
	}
}

static pid_t
spawn(char **argv, int *p)
{
	pid_t pid;

	switch ((pid = fork())) {
	case -1:
		syslog(LOG_ERR, "(daemon) fork: %s", strerror(errno));
		exit(1);
		break;
	case 0:
		close(p[0]);

		if (dup2(p[1], 1) == -1 || dup2(p[1], 2) == -1) {
			syslog(LOG_ERR, "dup2 log pipe: %s",
			    strerror(errno));
			exit(1);
		}

		fputs("(daemon) executing", stderr);
		for (char **arg = argv; *arg != NULL; arg++)
			fprintf(stderr, " %s", *arg);
		fputc('\n', stderr);

		execvp(*argv, argv);
		err(127, "execvp %s", *argv);
		break;
	default:
		close(p[1]);
	}

	return pid;
}

static void
sighandler_forward(int sig)
{
	if (child > 0) {
		syslog(LOG_INFO, "(daemon) forwarding signal %d to child %d",
		    sig, child);

		if (kill(child, sig) == -1)
			syslog(LOG_ERR, "(daemon) kill: %s", strerror(errno));
	} else {
		syslog(LOG_INFO, "(daemon) child not ready, not forwarding signal %d",
		    sig);
	}

	if (flag_restart && (sig == SIGTERM || sig == SIGKILL)) {
		flag_restart = 0;
		syslog(LOG_INFO, "(daemon) disabling auto-restart");
	}
}

static void
sighandler_die(int sig)
{
	syslog(LOG_INFO, "(daemon) got signal %d, exiting now releasing child",
	    sig);
	exit(0);
}

static void
setusergroup(char *user)
{
	struct passwd *pw;
	gid_t gr[128];
	int n;

	syslog(LOG_ERR, "(daemon) setting user to %s", user);

	if ((pw = getpwnam(user)) == NULL) {
		syslog(LOG_ERR, "(daemon) unknown user %s", user);
		exit(1);
	}

	n = sizeof gr / sizeof *gr;
	if (getgrouplist(user, 0, gr, &n) == -1) {
		syslog(LOG_ERR, "(daemon) inconsistent passwd and group: %s",
		    strerror(errno));
		exit(1);
	}

	for (int i = 0; i < n; i++) {
		if (setgid(gr[i]) == -1) {
			syslog(LOG_ERR, "(daemon) setting gid: %s",
			    strerror(errno));
			exit(1);
		}
	}

	if (setgid(pw->pw_gid) == -1 || setuid(pw->pw_uid) == -1) {
		syslog(LOG_ERR, "(daemon) setting uid %d gid %d: %s",
		    pw->pw_uid, pw->pw_gid, strerror(errno));
		exit(1);
	}
}

static void
spawn_logger(char **argv)
{
	int p[2], status;

	/* to catch error messages from the child */
	if (pipe(p) == -1) {
		syslog(LOG_ERR, "(daemon) pipe: %s", strerror(errno));
		exit(1);
	}

	/* fork-exec the child */
	child = spawn(argv, p);

	/* read logs until pipe close, like the logger(1) command */
	logger(p[0]);

	/* SIGCHLD should not be caught for this to work */
	while (waitpid(child, &status, 0) == -1)
		assert(errno == EINTR);
	assert(WIFEXITED(status) || WIFSIGNALED(status));
	child = 0;

	/* the child is not expected to terminate on its own */
	syslog(LOG_CRIT, "(daemon) child process exited with status %d",
	    WEXITSTATUS(status));
}

struct facility {
	char *name;
	int value;
} facilities[] = {
#define LOG(facility) { #facility, LOG_##facility }
	LOG(AUTH), LOG(AUTHPRIV), LOG(CRON), LOG(DAEMON), LOG(FTP), LOG(KERN),
	LOG(MAIL), LOG(NEWS), LOG(SYSLOG), LOG(USER), LOG(UUCP), LOG(LOCAL0),
        LOG(LOCAL1), LOG(LOCAL2), LOG(LOCAL3), LOG(LOCAL4), LOG(LOCAL5),
	LOG(LOCAL6), LOG(LOCAL7),
#undef LOG
	{ NULL, 0 }
};

static int
facility(char *name)
{
	for (struct facility *f = facilities; f->name != NULL; f++)
		if (strcasecmp(f->name, name) == 0)
			return f->value;
	return -1;
}

static void
usage(void)
{
	fprintf(stderr, "usage: %s [-012r] [-d chdir] [-u user] [-l facility] command [args...]\n",
	    arg0);

	fprintf(stderr, "facility: ");
	for (struct facility *f = facilities; f->name != NULL; f++)
		fprintf(stderr, f > facilities ? ", %s" : "%s", f->name);
	fputc('\n', stderr);

	exit(1);
}

void
daemon_(char **argv)
{
	struct sigaction sa;

	for (int i = 0; i <= 2; i++)
		if ((flag_no_close & 1 << i) == 0)
			close(i);

	/* double fork: daemonize */
	switch (fork()) {
	case -1:
		syslog(LOG_ERR, "(daemon) pipe: %s", strerror(errno));
		exit(1);
	case 0:
		break;
	default:
		return;
	}

	/* if specified, set user and associated groups */
	if (flag_user != NULL)
		setusergroup(flag_user);

	/* new process group with daemon itself and its child */
	if (setsid() == -1) {
		syslog(LOG_ERR, "(daemon) setsid: %s", strerror(errno));
		exit(1);
	}

	if (flag_dir) {
		syslog(LOG_ERR, "(daemon) chdir %s: %s",
			flag_dir, strerror(errno));
		if (chdir(flag_dir) == -1) {
			syslog(LOG_ERR, "chdir %s: %s",
				flag_dir, strerror(errno));
			exit(1);
		}
	}

	/* forward most signals to the child */
	sa.sa_handler = sighandler_forward;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGHUP, &sa, NULL);
	sigaction(SIGINT, &sa, NULL);
	sigaction(SIGQUIT, &sa, NULL);
	sigaction(SIGALRM, &sa, NULL);
	sigaction(SIGTERM, &sa, NULL);
	sigaction(SIGCONT, &sa, NULL);
	sigaction(SIGWINCH, &sa, NULL);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);

	/* to exit daemon itself but not the child */
	sa.sa_handler = sighandler_die;
	sigfillset(&sa.sa_mask);
	sigaction(SIGABRT, &sa, NULL);

	for (;;) {
		spawn_logger(argv);

		if (flag_restart) {
			syslog(LOG_CRIT, "(daemon) restarting in %d second",
				flag_restart);
			sleep(flag_restart);
		} else {
			syslog(LOG_CRIT, "(daemon) terminating");
			return;
		}
	}
}

int
main(int argc, char **argv)
{
	arg0 = *argv;
	for (int c; (c = getopt(argc, argv, "012d:l:ru:")) != -1;) {
		switch (c) {
		case '0':
		case '1':
		case '2':
			flag_no_close |= 1u << (c - '0');
			break;
		case 'd':
			flag_dir = optarg;
			break;
		case 'l':
			if ((flag_facility = facility(optarg)) == -1)
				usage();
			break;
		case 'r':
			flag_restart = 1;
			break;
		case 'u':
			flag_user = optarg;
			break;
		default:
			usage();
		}
	}
	argv += optind;
	argc -= optind;

	if (*argv == NULL)
		usage();

	openlog(*argv, LOG_CONS|LOG_NDELAY|LOG_PID, flag_facility);

	daemon_(argv);

	return 0;
}
