#!/usr/bin/awk -f

{
	current_symbol = $2

	file = $4
	gsub(/:.*$/, "", file)

	count[file]++

	# stash lines not duplicated within a single file
	if (count[file] == 1)
		lines[line_count++] = $0

	if (current_symbol == last_symbol) {

		#print file " " $0

	} else {
		# print unique lines for last symbol
		if (line_count > 1) {
			for (l in lines) {
				print lines[l]
			}
		}

		# reset state for next symbol
		delete count # reset file count array
		delete lines
		line_count = 0
	}

	last_symbol = current_symbol
}
