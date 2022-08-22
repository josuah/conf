export V=master

pack_download_git https://github.com/raspberrypi/pico-sdk
c++ -I src/common/boot_uf2/include -o elf2uf2 tools/elf2uf2/main.cpp
