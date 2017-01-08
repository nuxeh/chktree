#!/usr/bin/awk -f

/^TREES=/ {
	count++
	print "Found TREES"
}
END {
	if (count == 0)
		print "Please provide TREES environment variable"
}
