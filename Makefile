all: build-static-databases build run-tests report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt
PWD=$(shell pwd -P)

# enable debugging symbols, build kernel, save list of filenames from CC lines
build-kernel:
	cd $(KERNPATH) && \
	make clean && \
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ts001_ic_defconfig && \
	./scripts/config -e CONFIG_DEBUG_INFO && \
	yes '' | make ARCH=arm oldconfig && \
	make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage dtbs \
	| awk '/CC/{print $NF}' > $(PWD)/compiled-objects

objdump:
	true

report:
	true
