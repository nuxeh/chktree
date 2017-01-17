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

FNR == 1 {asort(paths, paths_s, "cmp_len_val")}

END {
	for (a in paths_s)
		print paths_s[a]
}

function cmp_len_val(i1, v1, i2, v2) {
	return length(v2) - length(v1)
}
