export V=master MAKE=gmake

tool='
	--enable-magic
	--enable-netgen
	--enable-irsim
	--enable-openlane
	--enable-qflow
	--enable-xschem
'
sky130='
	--enable-alpha-sky130
	--enable-xschem-sky130
	--enable-klayout-sky130
	--enable-precheck-sky130
	--enable-sram-sky130
	--enable-osu-t12-sky130
	--enable-osu-t15-sky130
	--enable-osu-t18-sky130
'
gf180='
	--enable-primitive-gf180mcu
	--enable-io-gf180mcu
	--enable-sc-7t5v0-gf180mcu
	--enable-sc-9t5v0-gf180mcu
	--enable-sram-gf180mcu
'

pack_download_git https://github.com/RTimothyEdwards/open_pdks
pack_configure $sky130 $gf180
pack_make
