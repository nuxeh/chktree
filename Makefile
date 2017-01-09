all: cscope.out report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt

PWD=$(shell pwd -P)
CC=arm-linux-gnueabihf-
DEFCONFIG=ts001_ic_defconfig

# enable debugging symbols, build kernel, save list of object filenames from
# CC lines in kbuild output
compiled-objects compiled-source:
	cd $(KERNPATH) && \
		make clean && \
		make ARCH=arm CROSS_COMPILE=$(CC) $(DEFCONFIG) && \
		./scripts/config -e CONFIG_DEBUG_INFO && \
		yes '' | make ARCH=arm oldconfig && \
		make -j8 ARCH=arm CROSS_COMPILE=$(CC) zImage dtbs 2>&1 \
		| awk '/CC/{print $$NF}' > /tmp/compiled-objects
	# create file lists in local dir
	sort /tmp/compiled-objects | grep '\.o$$' > compiled-objects
	sort /tmp/compiled-objects \
	| awk -F '.' -v OFS='.' '/\.o$$/{$$NF = "c"; print}' > compiled-source

# use objdump to extract debugging symbols describing the header files
# included to make build compiled object
compiled-headers: compiled-objects
	for file in `cat compiled-objects`; do \
		$(CC)objdump -W $(KERNPATH)/$$file \
		| ./filter-objdump.awk >> /tmp/compiled-headers; done
	sort /tmp/compiled-headers | uniq > compiled-headers

# make cscope.files, telling scsope which files to look at
cscope.files: compiled-source compiled-headers compiled-objects
	cat compiled-source compiled-headers | sort > cscope.files

# make cscope database
cscope.out: cscope.files
	cp cscope.files $(KERNPATH)
	cd $(KERNPATH) && \
		cscope -b

# run tests
report: compiled-headers compiled-objects cscope.files
	./run-tests.awk 

clean:
	rm compiled-source compiled-headers compiled-objects \
		$(KERNELPATH)/cscope.out
