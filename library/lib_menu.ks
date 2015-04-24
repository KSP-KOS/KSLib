// This script shows a menu on the terminal allowing user to
// select one of the options and return it to calling script.

@lazyglobal off.

function make_menu{
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

// This script shows a number enter menu on the terminal allowing user to
// type in any number (including floating point ones) and return
// it to calling script.
function input_number{
	parameter title.
	clearscreen.
	local num1 is 0.
	local num2 is 0.
	local dot_encountered is 0.
	local choices is list(0,1,2,3,4,5,6,7,8,9,".","Clear","Enter").
	until false{
		local t is "".
		if dot_encountered=0{
			set t to num1+"_".
		}
		else if dot_encountered=1{
			set t to num1+"._".
		}
		else{
			set t to num1+".".
			if num2=0{
				local i is 1.
				until i=dot_encountered{
					set t to t+"0".
					set i to i+1.
				}
			}
			else{
				local i is dot_encountered-2.
				until num2>(10^i - 0.00000001){
					set t to t+"0".
					set i to i-1.
				}
				set t to t+num2.
			}
			set t to t+"_".
		}
		wait 0.0001.
		local choice is make_menu(title+" "+t,choices).
		if choice="Enter"{
			return num1+0.1^dot_encountered*num2*10.
		}
		else if choice ="Clear"{
			set num1 to 0.
			set num2 to 0.
			set dot_encountered to 0.
		}
		else if choice="."{
			set dot_encountered to 1.
		}
		else{
			if dot_encountered{
				set num2 to num2*10+choice.
				set dot_encountered to dot_encountered+1.
			}
			else{
				set num1 to num1*10+choice.
			}
		}
	}
}
