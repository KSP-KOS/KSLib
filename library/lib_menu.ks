// This script shows a menu on the terminal allowing user to
// select one of the options and return it to calling script.

@lazyglobal off.

function open_menu{
	parameter title.
	parameter list_of_names.

	local current_option is 0.
	local len is list_of_names:length().
	local eq_string is "+".
	local i is 0.
	until i+2=terminal:width{
		set eq_string to eq_string+"=".
		set i to i+1.
	}
	set eq_string to eq_string+"+".

	clearscreen.
	print eq_string at(0,0).
	print "MENU" at (terminal:width/2-1,0).
	set i to 0.
	until i=len+8{
		print "|" at(0,i+1).
		print "|" at(terminal:width-1,i+1).
		set i to i+1.
	}
	print title at(2,2).
	set i to 0.
	until i=len{
		print "[ ] "+list_of_names[i] at(2,i+4).
		set i to i+1.
	}
	print eq_string at(0,len+5).
	print "AG7/8 - move up/down, AG9 - select" at(2,len+7).
	print eq_string at(0,len+9).
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
	return list_of_names[current_option].
}
