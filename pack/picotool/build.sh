export V=master
export PICO_SDK_PATH="$PWD/pico-sdk"

pack_download_git https://github.com/raspberrypi/picotool
if [ ! -d "$PICO_SDK_PATH" ]; then
	git clone --depth 1 https://github.com/raspberrypi/pico-sdk "$PICO_SDK_PATH"
fi
pack_cmake
pack_make
