#!/usr/bin/awk -f

/^ARGV[1]=/ { count++ }
END { if (count == 0) {
	print "Please provide " ARGV[1] " environment variable"
	exit 1
}}
