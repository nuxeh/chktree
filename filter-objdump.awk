#!/usr/bin/awk -f

/The Directory Table/ {state++}
/The File Name Table/ {state++}
/^$/ {if (state == 2) exit}

{
	if (state == 1) {
		print "1: " $0

	} else if (state == 2) {
		print "2: " $0


	}
}

