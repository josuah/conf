export V=main

exec cat <<EOF
su root -c 'git clone https://github.com/StefanSchippers/xschem_sky130 "$PREFIX/share/xschem/xschem_sky130"'
EOF
