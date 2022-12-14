#!/usr/bin/awk -f
# portable pstree implementation with POSIX ps(1) as back-end

function pager(msg)
{
	printf "%s", msg | "exec ${PAGER:-less -S}"
}

function ps_read(ps,
	i, pid, cmd)
{
	cmd = "exec ps ax -o pid,ppid,pgid,stat,user,args"
	cmd | getline
	while ((cmd | getline) > 0) {
		pid = $1

		ps[$2":cpid"] = ps[$2":cpid"] "," $1
		ps[pid":pgid"] = $3

		sub("^( *[^ ]+ +){3}", "")
		ps[pid":info"] = $0

		len = length($0)

		sub("^( *[^ ]+ +){2}", "")
		ps[pid":args"] = $0

		len -= length($0)
		ps[pid":info"] = substr(ps[pid":info"], 1, len)
	}
	close(cmd)
}

# Using the informations from the child pid in ps[], build the absolute
# path from PID 1 to each pid:
#	[1:pid]=1, [1:info]="", [1:1]=NODE, [1:args]="",
#	[2:pid]=4, [2:info]="", [2:1]=LINE, [2:2]=NODE, [2:args]="",
#	[3:pid]=7, [3:info]="", [3:1]=LINE, [3:2]=LINE, [3:3]=NODE, [3:args]="",
#	[4:pid]=9, [4:info]="", [4:1]=LINE, [4:2]=LINE, [4:3]=NODE, [4:args]="",

function tree_fill(tree, ps, pid, n, lv,
	i, cpid)
{
	for (i = 0; i < lv; i++)
		tree[n":"i] = LINE
	tree[n":"lv] = NODE
	tree[n":info"] = ps[pid":info"]
	tree[n":args"] = ps[pid":args"]
	tree[n":pid"] = pid
	tree[n":pgid"] = ps[pid":pgid"] == pid ? "*" : " "
	n++

	cpid = ps[pid":cpid"]
	while (sub("[^,]*,", "", cpid)) {
		pid = cpid
		sub(",.*", "", pid)
		n = tree_fill(tree, ps, pid, n, lv + 1)
	}

	return n
}

# Transform tree[] into a tree by replacing some LINE by VOID when needed.
# The tree is walked from the bottom to the top, and column by column
# toward the right until an empty column is met.

function tree_format(tree, n,
	i1, i2, stop, tail)
{
	for (i2 = 0; !stop; i2++) {
		stop = tail = 1
		for (i1 = n; i1 > 0; i1--) {
			if (tree[i1":"i2] == LINE && tail) {
				tree[i1":"i2] = VOID
				stop = 0
			} else if (tree[i1":"i2] == NODE && tail) {
				tree[i1":"i2] = TAIL
				tail = stop = 0
			} else if (!tree[i1":"i2]) {
				tail = 1
			}
		}
	}
}

function tree_print(tree, n,
	i1, i2, pid, pgid, info)
{
	for (i1 = 1; i1 < n; i1++) {
		pid = tree[i1":pid"]
		pgid = tree[i1":pgid"]
		info = tree[i1":info"]
		pager(sprintf("%6d%s %s", pid, pgid, info))
		for (i2 = 1; tree[i1":"i2] != ""; i2++)
			pager(sprintf("%s", tree[i1":"i2]))
		pager(sprintf("%s\n", tree[i1":args"]))
	}
}

BEGIN {
	LINE = "|  "
	NODE = "|- "
	TAIL = "`- "
	VOID = "   "

	pid = (ARGC == 2) ? ARGV[1] : 1

	ps_read(ps)
	n = tree_fill(tree, ps, pid, 1)
	tree_format(tree, n)
	tree_print(tree, n)
}
