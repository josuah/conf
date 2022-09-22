export V=main

pack_download_git https://github.com/emscripten-core/emsdk.git
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
