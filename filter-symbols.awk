#!/usr/bin/awk -f

{
	current_symbol = $2

	file = $4
	gsub(/:.*$/, "", file)

	count[file]++

	if (current_symbol == last_symbol) {

		print file " " $0

	} else {
		# print last symbol


		delete count # reset file count array
	}

	last_symbol = current_symbol
}
