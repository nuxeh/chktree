all: build-static-databases build run-tests report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt
PWD=$(shell pwd -P)

# enable debugging symbols, build kernel, save list of filenames from CC lines
compiled-objects:
	cd $(KERNPATH) && \
	make clean && \
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ts001_ic_defconfig && \
	./scripts/config -e CONFIG_DEBUG_INFO && \
	yes '' | make ARCH=arm oldconfig && \
	make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage dtbs 2>&1 \
	| awk '/CC/{print $$NF}' > /tmp/compiled-objects
	# create file list in local dir
	sort /tmp/compiled-objects \
	| awk -F '.' -v OFS='.' '/\.o$$/{$$NF = "c"; print}' > compiled-objects

objdump:
	true

report:
	true
