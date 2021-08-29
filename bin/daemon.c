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
pid_t	 child;

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

int
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
	fprintf(stderr, "usage: %s [-u user] [-l facility] command [args...]\n",
	    arg0);

	fprintf(stderr, "facility: ");
	for (struct facility *f = facilities; f->name != NULL; f++)
		fprintf(stderr, f > facilities ? ", %s" : "%s", f->name);
	fputc('\n', stderr);

	exit(1);
}

void
logger(int fd)
{
	FILE *fp;
	char *line = NULL;
	size_t sz = 0;

	if ((fp = fdopen(fd, "r")) == NULL) {
		syslog(LOG_ERR, "(daemon) fdopen pipe: %s", strerror(errno));
		exit(1);
	}

	while (getline(&line, &sz, fp) > 0) {
		strchomp(line);
		syslog(LOG_NOTICE, "%s", line);
	}

	if (ferror(fp))
		syslog(LOG_ERR, "(daemon) reading from log pipe: %s",
		    strerror(errno));

	fclose(fp);
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
		if (dup2(p[1], 1) == -1 || dup2(p[1], 2) == -1) {
			syslog(LOG_ERR, "dup2 log pipe: %s",
			    strerror(errno));
			exit(1);
		}
		close(p[0]);

		fputs("(daemon) executing", stderr);
		for (char **arg = argv; *arg != NULL; arg++)
			fprintf(stderr, " %s", *arg);
		fputc('\n', stderr);

		execvp(*argv, argv);
		err(127, "execvp %s: %s", *argv, strerror(errno));
		break;
	default:
		close(p[1]);
	}

	return pid;
}

void
sighandler_forward(int sig)
{
	if (child > 0) {
		syslog(LOG_INFO, "(daemon) forwarding signal %d to child %d",
		    sig, child);
		if (kill(child, sig) == -1)
			syslog(LOG_ERR, "(daemon) kill: %s", strerror(errno));
	} else {
		syslog(LOG_INFO, "(daemon) child not ready, not sending signal %d",
		    sig);
	}
}

void
sighandler_die(int sig)
{
	syslog(LOG_INFO, "(daemon) got signal %d, exiting now releasing child",
	    sig);
	exit(0);
}

void
setusergroup(char *user)
{
	struct passwd *pw;
	gid_t gr[128];
	int n;

	syslog(LOG_ERR, "(daemon) setting user to %s", user);

	if ((pw = getpwnam(user)) == NULL) {
		syslog(LOG_ERR, "(daemon) user %s: %s",
		    user, strerror(errno));
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
daemon_(char **argv)
{
	struct sigaction sa;
	int p[2], status;

	close(0);

	/* double fork: daemonize */
	switch (fork()) {
	case -1:
		syslog(LOG_ERR, "(daemon) pipe: %s", strerror(errno));
		exit(1);
		break;
	case 0:
		break;
	default:
		return;
	}

	/* if specified, set user and associated groups */
	if (flag_user != NULL)
		setusergroup(flag_user);

	/* to cache error messages from the child */
	if (pipe(p) == -1) {
		syslog(LOG_ERR, "(daemon) pipe: %s", strerror(errno));
		exit(1);
	}

	/* new process group with daemon itself and its child */
	if (setsid() == -1) {
		syslog(LOG_ERR, "(daemon) setsid: %s", strerror(errno));
		exit(1);
	}

	/* fork-exec the child */
	child = spawn(argv, p);

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
	sigaction(SIGINFO, &sa, NULL);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);

	/* to exit daemon itself but not the child */
	sa.sa_handler = sighandler_die;
	sigfillset(&sa.sa_mask);
	sigaction(SIGABRT, &sa, NULL);

	/* read all logs until the pipe closes like logger(1) does */
	logger(p[0]);

	/* needs SIGCHLD not caught above but let to default */
	while (waitpid(child, &status, 0) == -1)
		assert(errno == EINTR);
	assert(WIFEXITED(status) || WIFSIGNALED(status));
	child = 0;

	/* the child is not expected to terminate on its own */
	syslog(LOG_CRIT, "(daemon) child process exited with status %d",
	    WEXITSTATUS(status));
}

int
main(int argc, char **argv)
{
	arg0 = *argv;
	for (char c; (c = getopt(argc, argv, "u:l:")) != -1;) {
		switch (c) {
		case 'u':
			flag_user = optarg;
			break;
		case 'l':
			if ((flag_facility = facility(optarg)) == -1)
				usage();
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
