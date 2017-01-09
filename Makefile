all: build-static-databases build run-tests report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt
PWD=$(shell pwd -P)
CC=arm-linux-gnueabihf-

# enable debugging symbols, build kernel, save list of filenames from CC lines
compiled-objects compiled-source:
	cd $(KERNPATH) && \
	make clean && \
	make ARCH=arm CROSS_COMPILE=$(CC) ts001_ic_defconfig && \
	./scripts/config -e CONFIG_DEBUG_INFO && \
	yes '' | make ARCH=arm oldconfig && \
	make -j8 ARCH=arm CROSS_COMPILE=$(CC) zImage dtbs 2>&1 \
	| awk '/CC/{print $$NF}' > /tmp/compiled-objects
	# create file lists in local dir
	sort /tmp/compiled-objects | grep '\.o$$' > compiled-objects
	sort /tmp/compiled-objects \
	| awk -F '.' -v OFS='.' '/\.o$$/{$$NF = "c"; print}' > compiled-source

compiled-headers: compiled-objects
	for file in `cat compiled-objects`; do \
		$(CC)objdump -W $(KERNPATH)/$$file \
		| ./filter-objdump.awk >> /tmp/compiled-headers; done
	sort /tmp/compiled-headers | uniq > compiled-headers

cmake.files: compiled-source compiled-headers compiled-objects
	cat compiled-source compiled-headers > cmake.files

$(KERNPATH)/cmake.out:
	true

report: compiled-headers compiled-objects cmake.files
	true
