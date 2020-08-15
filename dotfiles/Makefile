all:
	find * \
	  -name Makefile -o \
	  -type d -exec mkdir -p "$$HOME/.{}" \; -o \
	  -type f -exec ln -sf "$$PWD/{}" "$$HOME/.{}" \;
