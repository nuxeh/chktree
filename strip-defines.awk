#!/usr/bin/awk -f

/#define/ {
	gsub(/\.\*/, "", $0)
	print $1 ":" $3 " " $NF
}
