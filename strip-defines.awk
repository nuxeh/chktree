#!/usr/bin/awk -f

/#define/ {
	ORS = ""
	gsub(/\.\*/, "", $0)
	print $1 ":" $2
	for (i=3; i<=NF; i++)
		print " " $i
	print "\n"
}
