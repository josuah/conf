CONF = vm.conf qemu-ifup qemu-ifdown qemu-start dhcpd/hypervisor.conf \
  hostname.veb0 hostname.vport0

include conf/mk/conf.mk

dhcpd.conf: dhcpd/hypervisor.conf

dhcpd/hypervisor.conf: vmtab

dhcpd:
	mkdir -p $@
