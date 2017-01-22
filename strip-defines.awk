#!/usr/bin/awk -f

BEGIN { ORS = "" }

/#define/ {
	gsub(/\.\*/, "", $0)

	# print file:line
	print "DEF " $4 " | " $1 ":" $2 " |"

	# print remainder
	for (i=3; i<=NF; i++)
		print " " $i
	print "\n"
}
