#!/usr/bin/awk -f
# check expiry date of a domain name using whois

BEGIN {
	cmd = "whois '"ARGV[1]"'"
	while (cmd | getline) {
		$0 = tolower($0)
		if (match($0, /.*expir[^:]*:[^0-9]*$/)) {
			cmd | getline
			break;
		} else if (gsub(".*expir[^:]*:[ \t]*", "")) {
			break;
		}
	}
	date = tolower($0)

	month["01"] = "january"
	month["02"] = "february"
	month["03"] = "march"
	month["04"] = "april"
	month["05"] = "may"
	month["06"] = "june"
	month["07"] = "jully"
	month["08"] = "august"
	month["09"] = "september"
	month["10"] = "october"
	month["11"] = "november"
	month["12"] = "december"
	for (m in month) {
		sub(month[m], m, date)
		sub(substr(month[m], 1, 3), m, date)
	}

	if (match(date, "[2][0-9][0-9][0-9][-/ ][0-1][0-9][-/ ][0-3][0-9]")) {
		y = substr(date, RSTART + 0, 4)
		m = substr(date, RSTART + 5, 2)
		d = substr(date, RSTART + 8, 2)
		date = y"-"m"-"d
	} else if (match(date, "[0-3][0-9][-/ ][0-1][0-9][-/ ][2][0-9][0-9][0-9]")) {
		d = substr(date, RSTART + 0, 2)
		m = substr(date, RSTART + 3, 2)
		y = substr(date, RSTART + 6, 4)
		date = y"-"m"-"d
	} else if (match(date, "[0-1][0-9][-/ ][0-3][0-9][-/ ][2][0-9][0-9][0-9]")) {
		m = substr(date, RSTART + 3, 2)
		d = substr(date, RSTART + 0, 2)
		y = substr(date, RSTART + 6, 4)
		date = y"-"m"-"d
	} else {
		date = "????-??-??"
	}

	print date, ARGV[1]
}
