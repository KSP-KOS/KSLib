// lib_number_dialog.ks provides a dialog where the user can enter any number (including negative and fractional).
// Copyright © 2015 KSLib team 
// Lic. MIT
run lib_gui_box.

function open_number_dialog
{
	parameter title.
	parameter number.

	local increment is 1.

	clearscreen.

	draw_gui_box(0, 0, terminal:width, 10).

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
