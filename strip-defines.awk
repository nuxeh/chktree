#!/usr/bin/awk -f

BEGIN { ORS = "" }

/#define/ {
	gsub(/\.\*/, "", $0)

	# print file:line, strip parameters
	def_symbol = $4
	gsub(/\(.*$/,"",def_symbol)
	print "DEF " def_symbol " | " $1 ":" $2 " |"

	# print remainder
	for (i=3; i<=NF; i++)
		print " " $i
	print "\n"
} else {
	print $0 > other-stuff
}
