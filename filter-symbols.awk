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

	if (length($0) > max_path_length)
		max_path_length = length($0)

	next
}

# read input symbol list (remaining imput files)
ARGIND > 1 {
	last_symbol = current_symbol
	current_symbol = $2

	file = $4
	gsub(/:.*$/, "", file)

	if (current_symbol != last_symbol) {
		# print unique lines for last symbol
		if (line_count > 1) {
			for (l in lines) {
				print lines[l]
			}

			print ""
		}

		# reset state for next symbol
		delete count_files # reset file count array
		delete count_paths # reset file count array
		delete lines
		line_count = 0
	}

	for (a in paths) {
		if (match($0, paths[a])) {
			path = paths[a]
			break
		}
	}

	count_files[file]++
	count_paths[path]++

	path_fill = ""
	for (j=0; j<max_path_length - length(path); j++)
		path_fill = path_fill " "

	# stash lines not duplicated within a single file
	# and not within the same comparison path
	if (count_files[file] == 1 && count_paths[path] == 1){
		lines[line_count++] = path_fill path " | " $0
	}
}

# function for sorting by array value length
function cmp_len_val(i1, v1, i2, v2)
{
	return length(v2) - length(v1)
}
