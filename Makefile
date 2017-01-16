all: all-global-definitions report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt

# TODO: ENV var handling

PWD=$(shell pwd -P)
CC=arm-linux-gnueabihf-
DEFCONFIG=ts001_ic_defconfig

output:
	mkdir output

# enable debugging symbols, build kernel, save list of object filenames from
# CC lines in kbuild output
output/compiled-objects output/compiled-source: output
	cd $(KERNPATH) && \
		make clean && \
		make ARCH=arm CROSS_COMPILE=$(CC) $(DEFCONFIG) && \
		./scripts/config -e CONFIG_DEBUG_INFO && \
		yes '' | make ARCH=arm oldconfig && \
		make -j8 ARCH=arm CROSS_COMPILE=$(CC) zImage dtbs 2>&1 \
		| awk '/CC/{print $$NF}' > /tmp/compiled-objects
	# create file lists in local dir
	sort /tmp/compiled-objects | grep '\.o$$' > output/compiled-objects
	sort /tmp/compiled-objects \
	| awk -F '.' -v OFS='.' '/\.o$$/{$$NF = "c"; print}' \
	> output/compiled-source

# use objdump to extract debugging symbols describing the header files
# included to make build compiled object
output/compiled-headers: output/compiled-objects
	cd output && \
	for file in `cat compiled-objects`; do \
		$(CC)objdump -W $(KERNPATH)/$$file \
		| ../filter-objdump.awk >> /tmp/compiled-headers; done
	sort /tmp/compiled-headers | uniq > output/compiled-headers

# make cscope.files, telling scsope which files to look at
output/cscope.files: output/compiled-headers
	cd output && cat compiled-headers | sort > cscope.files

# make cscope database
$(KERNPATH)/cscope.out: cscope.files
	cp cscope.files $(KERNPATH)
	cd $(KERNPATH) && \
		cscope -b

# make a list of all global definitions in the files used for the build, using
# cscope
output/all-global-definitions: $(KERNPATH)/cscope.out
	cd $(KERNPATH) && \
		cscope -L -1 ".*" > $(PWD)/output/all-global-definitions

all-defines: all-global-definitions
	cd output && \
	cat all-global-definitions | ../strip-defines.awk > all-defines

all-prototypes: all-global-definitions


# run tests
report: all-defines all-prototypes
	./run-tests.awk

clean:
	rm -rf output
