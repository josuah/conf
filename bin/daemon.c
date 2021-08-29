#include <assert.h>
#include <sys/wait.h>
#include <syslog.h>
#include <unistd.h>
#include <signal.h>

#include "util.h"

char	*flag_user;
int	 flag_facility;
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

static void
daemon_(char **argv)
{
	struct sigaction sa;
	int p[2], status;

	close(0);

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

	if (pipe(p) == -1) {
		syslog(LOG_ERR, "(daemon) pipe: %s", strerror(errno));
		exit(1);
	}

	if (setsid() == -1) {
		syslog(LOG_ERR, "(daemon) setsid: %s", strerror(errno));
		exit(1);
	}

	child = spawn(argv, p);

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

	sa.sa_handler = sighandler_die;
	sigfillset(&sa.sa_mask);
	sigaction(SIGABRT, &sa, NULL);

	logger(p[0]);

	while (waitpid(child, &status, 0) == -1)
		assert(errno == EINTR);
	assert(WIFEXITED(status) || WIFSIGNALED(status));
	child = 0;
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
