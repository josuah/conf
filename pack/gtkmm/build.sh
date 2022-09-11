export V=3.24.6

pack_download_txz https://download.gnome.org/sources/gtkmm/${V%.*}/gtkmm-$V.tar.xz 
pack_meson
pack_ninja
