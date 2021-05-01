ver=master
url=https://github.com/mptre/mdsort.git

pack_download(){
	pack_download_git
	cd "$SOURCE"

# https://github.com/mptre/mdsort/pull/1

patch -p1 <<'__EOF__'
diff --git a/extern.h b/extern.h
index 4f8fe15..aee01fd 100644
--- a/extern.h
+++ b/extern.h
@@ -385,6 +385,7 @@ struct macro_list {
 };
 
 void macros_init(struct macro_list *, unsigned int);
+void macros_free(struct macro_list *);
 int macros_insert(struct macro_list *, char *, char *, int);
 void macros_insertc(struct macro_list *, const char *, const char *);
 struct macro *macros_find(const struct macro_list *, const char *);
@@ -411,7 +412,7 @@ struct config_list {
 	TAILQ_HEAD(, config) cf_list;
 };
 
-struct config_list *config_parse(const char *, const struct environment *);
+struct config_list *config_parse(const char *, const struct environment *, struct macro_list *);
 
 void config_free(struct config_list *);
 
diff --git a/mdsort.1 b/mdsort.1
index 68b8831..5d9cabe 100644
--- a/mdsort.1
+++ b/mdsort.1
@@ -7,6 +7,7 @@
 .Sh SYNOPSIS
 .Nm
 .Op Fl dnv
+.Op Fl D Ar macro=value
 .Op Fl f Ar file
 .Op Fl
 .Sh DESCRIPTION
@@ -26,6 +27,12 @@ output which messages would be moved with respect to the current rules.
 Specify an alternative configuration file.
 .It Fl n
 Check if the configuration file is valid.
+.It Fl D Ar macro=value
+Define
+.Ar macro
+to be set to
+.Ar value
+on the command line.
 .It Fl v
 Verbose mode.
 Multiple
diff --git a/mdsort.c b/mdsort.c
index c82deeb..5e7ed18 100644
--- a/mdsort.c
+++ b/mdsort.c
@@ -42,8 +42,10 @@ main(int argc, char *argv[])
 	struct maildir_entry me;
 	struct config_list *config;
 	struct config *conf;
+	struct macro_list macros;
 	struct maildir *md;
 	struct message *msg;
+	char *eq;
 	int c, w;
 	int error = 0;
 	int reject = 0;
@@ -56,7 +58,9 @@ main(int argc, char *argv[])
 	memset(&env, 0, sizeof(env));
 	TAILQ_INIT(&matches);
 
-	while ((c = getopt(argc, argv, "dnvf:")) != -1)
+	macros_init(&macros, MACRO_CTX_DEFAULT);
+
+	while ((c = getopt(argc, argv, "dnvf:D:")) != -1)
 		switch (c) {
 		case 'd':
 			env.ev_options |= OPTION_DRYRUN;
@@ -70,6 +74,12 @@ main(int argc, char *argv[])
 		case 'v':
 			log_level++;
 			break;
+		case 'D':
+			if ((eq = strchr(optarg, '=')) == NULL)
+				err(1, "invalid macro: %s", optarg);
+			*eq = '\0';
+			macros_insertc(&macros, optarg, eq + 1);
+			break;
 		default:
 			usage();
 		}
@@ -94,7 +104,7 @@ main(int argc, char *argv[])
 
 	if (env.ev_confpath == NULL)
 		env.ev_confpath = defaultconf(env.ev_home);
-	config = config_parse(env.ev_confpath, &env);
+	config = config_parse(env.ev_confpath, &env, &macros);
 	if (config == NULL) {
 		error = 1;
 		goto out;
@@ -160,6 +170,7 @@ loop:
 
 out:
 	config_free(config);
+	macros_free(&macros);
 
 	FAULT_SHUTDOWN();
 
@@ -177,7 +188,7 @@ static __dead void
 usage(void)
 {
 
-	fprintf(stderr, "usage: mdsort [-dnv] [-f file] [-]\n");
+	fprintf(stderr, "usage: mdsort [-dnv] [-D macro=value] [-f file] [-]\n");
 	exit(1);
 }
 
diff --git a/parse.y b/parse.y
index c7e823f..6014004 100644
--- a/parse.y
+++ b/parse.y
@@ -23,7 +23,6 @@ static void yyungetc(int);
 static void yypushl(int);
 static void yypopl(void);
 
-static void macros_free(struct macro_list *);
 static void macros_validate(const struct macro_list *);
 
 static char *expand(char *, unsigned int);
@@ -430,7 +429,7 @@ nl		: '\n' optnl
  * Otherwise, NULL is returned.
  */
 struct config_list *
-config_parse(const char *path, const struct environment *env)
+config_parse(const char *path, const struct environment *env, struct macro_list *macros)
 {
 	yyfh = fopen(path, "r");
 	if (yyfh == NULL) {
@@ -439,11 +438,7 @@ config_parse(const char *path, const struct environment *env)
 	}
 	yypath = path;
 	yyenv = env;
-
-	yyconfig.cf_macros = malloc(sizeof(*yyconfig.cf_macros));
-	if (yyconfig.cf_macros == NULL)
-		err(1, NULL);
acros, MACRO_CTX_DEFAULT);
+	yyconfig.cf_macros = macros;
 
 	TAILQ_INIT(&yyconfig.cf_list);
 
@@ -473,8 +468,6 @@ config_free(struct config_list *config)
 		free(conf->maildir.path);
 		free(conf);
 	}
-
-	macros_free(config->cf_macros);
 }
 
 static void
@@ -853,26 +846,6 @@ yypopl(void)
 	lineno_save = -1;
 }
 
-static void
-macros_free(struct macro_list *macros)
-{
-	struct macro *mc;
-
-	if (macros == NULL)
-		return;
-
-	while ((mc = TAILQ_FIRST(&macros->ml_list)) != NULL) {
-		TAILQ_REMOVE(&macros->ml_list, mc, mc_entry);
-		if ((mc->mc_flags & MACRO_FLAG_CONST) == 0) {
-			free(mc->mc_name);
-			free(mc->mc_value);
-		}
-		if ((mc->mc_flags & MACRO_FLAG_STATIC) == 0)
-			free(mc);
-	}
-	free(macros);
-}
-
 static void
 macros_validate(const struct macro_list *macros)
 {
diff --git a/util.c b/util.c
index 90ceb8b..66e5024 100644
--- a/util.c
+++ b/util.c
@@ -98,6 +98,22 @@ macros_init(struct macro_list *macros, unsigned int ctx)
 	TAILQ_INIT(&macros->ml_list);
 }
 
+void
+macros_free(struct macro_list *macros)
+{
+	struct macro *mc;
+
+	while ((mc = TAILQ_FIRST(&macros->ml_list)) != NULL) {
+		TAILQ_REMOVE(&macros->ml_list, mc, mc_entry);
+		if ((mc->mc_flags & MACRO_FLAG_CONST) == 0) {
+			free(mc->mc_name);
+			free(mc->mc_value);
+		}
+		if ((mc->mc_flags & MACRO_FLAG_STATIC) == 0)
+			free(mc);
+	}
+}
+
 int
 macros_insert(struct macro_list *macros, char *name, char *value, int lno)
 {
__EOF__

}
