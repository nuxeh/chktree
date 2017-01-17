#!/usr/bin/awk -f

BEGIN {

}

# read file list
ARGIND == 1 {
	paths[count++] = $0
}

# read source lists
ARGIND > 1 {
	print "> " $0
	
}

END {
	for (a in paths)
		print paths[a]
}
