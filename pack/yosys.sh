v=master
url=https://github.com/yosyshq/yosys.git

pack_configure()
{
	patch -Np1 </etc/pack/yosys.patch
	gmake ENABLE_TCL=0 config-clang
}

pack_build()
{
	gmake ENABLE_TCL=0
}

# [ 95%] ABC: `` Compiling: /src/base/main/mainReal.c
# src/base/main/mainReal.c:144:27: error: use of undeclared identifier 'RLIMIT_AS'
#                 setrlimit(RLIMIT_AS, &limit);
#                           ^
# 1 error generated.
# gmake[1]: *** [Makefile:177: src/base/main/mainReal.o] Error 1
# gmake: *** [Makefile:758: abc/abc-d7ecb23] Error 2
