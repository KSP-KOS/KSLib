// This file is distributed under the terms of the MIT license, (c) the KSLib team

function open_number_dialog
{
	parameter title.
	parameter number.

	local increment is 1.

	clearscreen.
	
	local eq_string is "+".
	local space_string is "|".
	local i is 0.
	until i+2=terminal:width{
		set eq_string to eq_string+"=".
		set space_string to space_string+" ".
		set i to i+1.
	}
	set space_string to space_string+"|".
	set eq_string to eq_string+"+".
	print eq_string at(0,0).
	set i to 0.
	until i=8{
		print space_string at(0,1+i).
		set i to i+1.
	}
	print eq_string at(0,9).

	print "6/7 - number    -/+" at (2, 5).
	print "8/9 - increment -/+" at (2, 6).
	print "0   - enter" at (2, 7).

	local old_decrease is ag6.
	local old_increase is ag7.
	local old_div10 is ag8.
	local old_mul10 is ag9.
	local old_enter is ag10.
	local spaces is "      ".

	until old_enter <> ag10{
		print title + " "+number+spaces at (2, 2).
		print "Increment: " + increment+spaces at (2, 3).

		if old_increase <> ag7{
			set old_increase to ag7.
			set number to number + increment.
		}
		if old_decrease <> ag6{
			set old_decrease to ag6.
			set number to number - increment.
		}
		if old_div10 <> ag8{
			set old_div10 to ag8.
			set increment to increment / 10.
		}
		if old_mul10 <> ag9{
			set old_mul10 to ag9.
			set increment to increment * 10.
		}
	}

	clearscreen.

	return number.
}
