// lib_menu.ks - select one of the options and return it to calling script.
// Copyright © 2015 KSLib team 
// Lic. MIT

@lazyglobal off.

run lib_gui_box.

function open_menu_indexed{
	parameter title.
	parameter list_of_names.

	if list_of_names:empty{
		print "error: list_of_names should not be empty". print 1/0.
	}

	local current_option is 0.
	local len is list_of_names:length().

	clearscreen.
	print title at(2,2).
	local i is 0.
	until i=len{
		print "[ ] "+list_of_names[i] at(2,i+4).
		set i to i+1.
	}
	draw_gui_box(0, 0, terminal:width, len + 6).
	print "AG7/8 - move up/down, AG9 - select" at(2,len+7).
	draw_gui_box(0, len + 5, terminal:width, 5).
	print "*" at(3,4).

	until false{
		local last_up is ag7.
		local last_down is ag8.
		local last_sel is ag9.
		wait until ag7<>last_up or ag8<>last_down or ag9<>last_sel.
		if ag7<>last_up{
			print " " at(3,4+current_option).
			set current_option to mod(current_option-1+len,len).
			print "*" at(3,4+current_option).
		}
		else if ag8<>last_down{
			print " " at(3,4+current_option).
			set current_option to mod(current_option+1,len).
			print "*" at(3,4+current_option).
		}
		else if ag9<>last_sel{
			break.
		}
	}

	clearscreen.
	return current_option.
}

function open_menu{
	parameter title.
	parameter list_of_names.

	return list_of_names[open_menu_indexed(title, list_of_names)].
}
