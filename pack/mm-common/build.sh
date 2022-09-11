export V=master

pack_download_git https://gitlab.gnome.org/GNOME/mm-common
pack_meson -Duse-network=true
pack_ninja
