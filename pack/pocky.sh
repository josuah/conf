v=dunfell
url=http://git.yoctoproject.org/git/poky.git

openembedded=git://git.openembedded.org/meta-openembedded
yoctoproject=git://git.yoctoproject.org/meta-virtualization

pack_download() {
        git clone --depth 1 -b "$ver" "$url" "$SOURCE"
        rm -rf "$SOURCE/.git"
	cd "$SOURCE"
	git clone -b "$ver" "$openembedded"
	git clone -b "$ver" "$yoctoproject"
}

pack_configure() {
	sed -i 's/ pr / /g; s/ sha[0-9]*sum / /g; s/ g++ / /g' \
	  meta/conf/bitbake.conf

	sed -i 's/--unique/-u/g' scripts/oe-buildenv-internal
	. ./oe-init-build-env

	sed -i '/BBLAYERS/,$ d' conf/bblayers.conf

cat <<__EOF__ >>conf/bblayers.conf
BBLAYERS ?= " \
$SOURCE/meta \
$SOURCE/meta-poky \
$SOURCE/meta-yocto-bsp \
$SOURCE/meta-openembedded/meta-oe \
$SOURCE/meta-openembedded/meta-filesystems \
$SOURCE/meta-openembedded/meta-python \
$SOURCE/meta-openembedded/meta-networking \
$SOURCE/meta-virtualization \
 "
__EOF__

cat <<__EOF__ >conf/local.conf
DL_DIR = "$PWD"
SSTATE_DIR = "$PWD"
PACKAGE_CLASSES = "package_ipk"
MACHINE = "qemuarm64"
DISTRO = "poky"
IMAGE_FSTYPES += "cpio.gz"
QEMU_TARGETS = "i386 aarch64"
DISTRO_FEATURES += " virtualization xen"
BUILD_REPRODUCIBLE_BINARIES = "1"
PACKAGECONFIG_pn-qemu += " virtfs xen fdt"
PACKAGECONFIG_remove_pn-qemu += " sdl"
__EOF__

}

pack_build() {
	. ./oe-init-build-env
	export HOSTTOOLS=ls PATH="$PATH:PWD"
	touch diffstat
	chmod +x diffstat
	bitbake xen-image-minimal
}
