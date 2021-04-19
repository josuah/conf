ver=master
url=https://github.com/openbgpd-portable/openbgpd-portable.git

pack_download() {
	pack_download_git
	cd "$SOURCE"

patch -p1 <<'__EOF__'
--- old/src/bgpd/kroute-disabled.c
+++ new/src/bgpd/kroute-disabled.c
@@ -305,6 +305,9 @@
 		struct sockaddr_in6 *m6;
 		int plen;
 
+		if (!ifa->ifa_addr)
+			continue;
+
 		switch (ifa->ifa_addr->sa_family) {
 		case AF_INET:
 			m4 = (struct sockaddr_in *)ifa->ifa_netmask;
__EOF__

}
pack_build() {
	make
}
