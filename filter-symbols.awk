#!/usr/bin/awk -f
#
# Take a list of paths and all input symbols, for each symbol, find symbols
# that are unique, but:
#
# - not duplicated within any given file
# - are not duplicated within the same comparison path, e.g. there are a lot
#   of duplicated results in code and include paths

BEGIN {
	PROCINFO["sorted_in"] = "cmp_len_val"
}

# read file list (first input file)
ARGIND == 1 {
	paths[path_count++] = $0;

	MAX_PATHS = 20
	if (path_count > MAX_PATHS) {
		print "Maximum number of paths (" MAX_PATHS ") exceeded"
		exit(1)
	}

	next
}

# read input symbol list (remaining imput files)
ARGIND > 1 {
	current_symbol = $2

	file = $4
	gsub(/:.*$/, "", file)

	if (current_symbol != last_symbol) {
		# print unique lines for last symbol
		if (line_count > 1) {
			for (l in lines) {
				print line_count "\t" lines[l]
			}
		}

		# reset state for next symbol
		delete count # reset file count array
		delete lines
		line_count = 0
	}

	for (a in paths) {
		if (match($0, paths[a])) {
			path = paths[a]
		}
	}

	count[file]++
	count[path]++

	# stash lines not duplicated within a single file
	# and not within the same comparison path
	if (count[file] == 1 && count[path] == 1)
		lines[line_count++] = path "\t" $0

	last_symbol = current_symbol
}

# function for sorting by array value length
function cmp_len_val(i1, v1, i2, v2)
{
	return length(v2) - length(v1)
}
