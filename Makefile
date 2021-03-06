all: all-global-definitions report

# todo deps - don't rebuild if file log is up-to-date, and kernel doesn't need
# to be rebuilt

# TODO: ENV var handling

PWD=$(shell pwd -P)
CC=arm-linux-gnueabihf-
DEFCONFIG=ts001_ic_defconfig
PATHS=$(PWD)/paths
KERNPATH=$(PWD)/../linux/

output:
	mkdir output

# enable debugging symbols, build kernel, save list of object filenames from
# CC lines in kbuild output
output/compiled-objects output/compiled-source: | output
	rm -f /tmp/compiled-objects
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
	rm -f /tmp/compiled-headers
	for file in `cat output/compiled-objects`; do \
		$(CC)objdump -W $(KERNPATH)/$$file \
		| $(PWD)/filter-objdump.awk >> /tmp/compiled-headers; done
	sort /tmp/compiled-headers | uniq > output/compiled-headers

# make cscope.files, telling scsope which files to look at
output/cscope.files: output/compiled-headers
	cd output && cat compiled-headers \
		| grep -v '\.c$$' | sort > cscope.files

# make cscope database
$(KERNPATH)/cscope.out: output/cscope.files
	cp output/cscope.files $(KERNPATH)
	cd $(KERNPATH) && \
		cscope -b

# make a list of all global definitions in the files used for the build, using
# cscope
output/all-global-definitions: $(KERNPATH)/cscope.out
	cd $(KERNPATH) && \
		cscope -L -1 ".*" | sort | uniq \
		> /tmp/all-global-definitions
	cd output && \
		cat /tmp/all-global-definitions \
		| $(PWD)/strip-defines.awk \
		| sort > all-global-definitions
	# TODO filter function protos

output/duplicates: output/all-global-definitions
	cd output && \
		./filter-symbols.awk $(PWD)/paths all-global-definitions \
		> duplicates

clean:
	rm -fv $(KERNPATH)/cscope.out report-*
	rm -rfv output
