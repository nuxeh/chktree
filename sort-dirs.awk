#!/usr/bin/awk -f

BEGIN {

}

FNR == 1 {++f_index}

# read file list
f_index == 1 {
	paths[count++] = $0
}

# read source lists
f_index > 1 {
	print "> " $0
	
}

END {
	for (a in paths)
		print paths[a]
}
