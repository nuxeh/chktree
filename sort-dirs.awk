#!/usr/bin/awk -f

BEGIN {
	PROCINFO["sorted_in"] = "cmp_len_val"
	counts["unmatched"] = 0
}

# read file list (first input file)
ARGIND == 1 {paths[count++] = $0}

# read source lists (other input files)
ARGIND > 1 {
	for (a in paths) {
		if (match($0, paths[a])) {
			if (debug) print paths[a]

			outfile = "sorted_path_" paths[a]
			gsub(/\//, "@", outfile)

			print $0 > outfile

			counts[paths[a]]++
			next
		}
	}
	counts["unmatched"]++
}

END {
	# print summary
	for (a in paths)
		print counts[paths[a]] ":\t" paths[a]
	print counts["unmatched"] " unmatched"
}

function cmp_len_val(i1, v1, i2, v2)
{
	return length(v2) - length(v1)
}
