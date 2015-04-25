@lazyglobal off.

run lib_window.

function open_window_number_dialog{
	parameter title.
	parameter number.
	parameter window.
	
	local process_state is list(
		list(false, window, "update_window_number_dialog",false),
		title,number,ag6,ag7,ag8,ag9,ag10,"      ",1).
	redraw_window_number_dialog(process_state).
	return process_state.
}

function redraw_window_number_dialog{
	parameter process_state.

	local window is process_state[0][1].
	
	print "6/7 - number    -/+" at (window[0]+2, window[1]+5).
	print "8/9 - increment -/+" at (window[0]+2, window[1]+6).
	print "0   - enter" at (window[0]+2, window[1]+7).
}

function update_window_number_dialog{
	parameter process_state.

	local title is process_state[1].
	local window is process_state[0][1].
	local number is process_state[2].
	local old_decrease is process_state[3].
	local old_increase is process_state[4].
	local old_div10 is process_state[5].
	local old_mul10 is process_state[6].
	local old_enter is process_state[7].
	local spaces is process_state[8].
	local increment is process_state[9].
	
	if process_state[0][3]{
		redraw_window_number_dialog(process_state).
	}

	if old_enter<>ag10{
		set process_state[0][0] to true.//finished
		return number.
	}
	print title +" "+ number+spaces at(window[0]+2,window[1]+2).
	print "Increment: "+increment+spaces at(window[0]+2,window[1]+3).
	if old_decrease <> ag6{
		set process_state[3] to ag6.
		set process_state[2] to number - increment.
	}
	if old_increase <> ag7{
		set process_state[4] to ag7.
		set process_state[2] to number + increment.
	}
	if old_div10 <> ag8{
		set process_state[5] to ag8.
		set process_state[9] to increment / 10.
	}
	if old_mul10 <> ag9{
		set process_state[6] to ag9.
		set process_state[9] to increment * 10.
	}

	return -1. //not finished yet.
}
