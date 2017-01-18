#!/usr/bin/awk -f

BEGIN {
	# store filename arguments
	for (arg in ARGV) {
		print ARGV[arg]
		a[arg] = ARGV[arg]
	}
}

{print FILENAME " " $0}
