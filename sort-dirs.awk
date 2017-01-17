#!/usr/bin/awk -f

BEGIN {

}

# read file list (first input file)
ARGIND == 1 {paths[count++] = $0}

# read source lists (other input files)
ARGIND > 1 {
	print "> " $0
	#find_match()
}

END {
	PROCINFO["sorted_in"] = "cmp_len_val"
	for (a in paths)
		print paths[a]
}

function cmp_len_val(i1, v1, i2, v2)
{
	print length(v2) "-" length(v1)
	return length(v2) - length(v1)
}
