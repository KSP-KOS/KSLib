// This script shows a menu on the terminal allowing user to
// select one of the options and return it to calling script.
@lazyglobal off.

run lib_window.

function open_window_menu{
	parameter title.
	parameter list_of_names.
	parameter window.

	local x is window[0].
	local y is window[1].
	
	local current_option is 0.
	local len is list_of_names:length().

	local last_up is ag7.
	local last_down is ag8.
	local last_sel is ag9.
	local process_state is list(
		list(false,window,"update_window_menu",false),
		current_option,last_up,last_down,last_sel,list_of_names,title
	).
	draw_window_menu(process_state).
	return process_state.
}

function draw_window_menu{ //this is opt-in function. If other programs'
	//developers don't want to react to terminal change, fine.
	parameter process_state.

	if not is_process_gui(process_state){
		return.
	}

	local x is process_state[0][1][0].
	local y is process_state[0][1][1].
	local list_of_names is process_state[5].
	local len is process_state[5]:length().
	local title is process_state[6].
	local current_option is process_state[1].

	print title at(x+2,y+2).
	local i is 0.
	until i=len{
		print "[ ] "+list_of_names[i] at(x+2,y+i+4).
		set i to i+1.
	}
	print "7/8/9 - up/down/select" at(x+2,y+len+5).
	//TODO: what if options dont fit on window? Scroll!
	print "*" at(x+3,y+4+current_option).
	set process_state[0][3] to false. //redraw no longer needed
}

function update_window_menu{
	parameter process_state.

	local window is get_process_window(process_state).
	local x is window[0].
	local y is window[1].
	local current_option is process_state[1].
	local last_up is process_state[2].
	local last_down is process_state[3].
	local last_sel is process_state[4].
	local len is process_state[5]:length().
	
	if process_needs_redraw(process_state){
		draw_window_menu(process_state).
	}

	if ag7<>last_up{
		print " " at(x+3,y+4+current_option).
		set current_option to mod(current_option-1+len,len).
		print "*" at(x+3,y+4+current_option).
		set process_state[2] to ag7.
		set process_state[1] to current_option.
	}
	else if ag8<>last_down{
		print " " at(x+3,y+4+current_option).
		set current_option to mod(current_option+1,len).
		print "*" at(x+3,y+4+current_option).
		set process_state[3] to ag8.
		set process_state[1] to current_option.
	}
	else if ag9<>last_sel{
		end_process(process_state).
		return process_state[5][current_option].
	}
	return "".
}
