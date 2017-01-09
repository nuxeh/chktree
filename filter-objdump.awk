#!/usr/bin/awk -f

BEGIN {OFS = "/"}

/The Directory Table/ {state++; next}
/The File Name Table/ {state++; next}
/^$/ {if (state == 2) exit}

{
	if (state == 1) {
		gsub(/^\.\//, "", $NF)
		dirs[$1] = $NF
	} else if (state == 2 && $2 != 0 && $NF != "Name") {
		print dirs[$2], $NF
	}
}

