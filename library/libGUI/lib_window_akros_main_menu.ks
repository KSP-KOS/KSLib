@lazyglobal off.

run lib_window.
run lib_window_menu.

function open_window_akros_main_menu{
	parameter
		list_of_windows,
		all_proc.

	local process_state to list(
		list(false,list_of_windows[0],"update_window_akros_main_menu",false),
		"title_screen",abort,"child_proc_place",all_proc,list_of_windows,
		"selected_program"
	).
	draw_window_akros_main_menu(process_state).
	return process_state.
}

function draw_window_akros_main_menu{
	parameter process_state.
	
	if not is_process_gui(process_state){
		return.
	}

	local window is get_process_window(process_state).

	print "aaa  k       OOOO SSSS" at(window[0]+2,window[1]+2).
	print "  a  k       O  O S   " at(window[0]+2,window[1]+3).
	print "aaa  k k rrr O  O SSSS" at(window[0]+2,window[1]+4).
	print "a a  kk  r   O  O    S" at(window[0]+2,window[1]+5).
	print "aaaa k k r   OOOO SSSS" at(window[0]+2,window[1]+6).

	print "Press Abort to start. " at(window[0]+2,window[1]+8).

	print "akrOS, by akrasuski1" at(window[0]+window[2]-21,
									window[1]+window[3]-1).
	
	set process_state[0][3] to false. // redraw no longer needed
}

function get_process_from_name{
	parameter
		program_name,
		list_of_windows,
		list_of_processes,
		selected_window_index.
	
	if program_name="Vessel stats"{
		return open_window_vessel_stats(
			list_of_windows[selected_window_index]
		).
	}
	else if program_name="qweqweqwe"{
		//etc.
	}
}

function update_window_akros_main_menu{
	parameter process_state.

	local run_mode is process_state[1].
	local wnd is get_process_window(process_state).
	
	if run_mode="title_screen"{
		if process_needs_redraw(process_state){
			draw_window_akros_main_menu(process_state).
		}

		local wnd is get_process_window(process_state).
		local last_abort is process_state[2].

		if abort<>last_abort{
			draw_outline(wnd).
			set process_state[1] to "program_selection".
			local child_process is open_window_menu(
				"Select program:",
				list("Vessel stats","Back","Quit akrOS"),
				wnd
			).
			set process_state[3] to child_process.
		}
	}
	else if run_mode="program_selection"{
		local child_process is process_state[3].
		if process_needs_redraw(process_state){ // pass redraw event to child
			invalidate_process_window(child_process).
			set process_state[0][3] to false. // redraw no longer needed
		}
		local selection is update_process(child_process).
		if process_finished(child_process){
			draw_outline(wnd).
			if selection="Quit akrOS"{
				local all_proc is process_state[4].
				local i is 0.
				until i=all_proc:length{
					end_process(all_proc[i]).
					set i to i+1.
				}
				return 0.
			}
			else if selection="Back"{
				set process_state[1] to "title_screen".
				invalidate_process_window(process_state).
			}
			else{
				local len is process_state[5]:length.
				local lw is list().
				local i is 0.
				until i=len{
					lw:add(i).
					set i to i+1.
				}
				set child_process to open_window_menu(
					"Select window",lw,wnd
				).
				set process_state[1] to "window_selection".
				set process_state[3] to child_process.
				set process_state[6] to selection.
			}
		}
	}
	else if run_mode="window_selection"{
		local child_process is process_state[3].
		if process_needs_redraw(process_state){ // pass redraw event to child
			invalidate_process_window(child_process).
			set process_state[0][3] to false. // redraw no longer needed
		}
		local selection is update_process(child_process).
		if process_finished(child_process){
			draw_outline(wnd).
			
			local other_process is get_process_from_name(
				process_state[6],process_state[5],process_state[4],selection
			).

			if selection<>0{ // menu is still there
				local all_proc is process_state[4].
				all_proc:add(other_process).
				invalidate_process_window(process_state).
				set process_state[1] to "title_screen".
			}
			else{ // menu must disappear to show program
				set process_state[3] to other_process.
				set process_state[1] to "waiting_for_foreground".
			}
		}
	}
	else if run_mode="waiting_for_foreground"{
		local child_process is process_state[3].
		if process_needs_redraw(process_state){ // pass redraw event to child
			invalidate_process_window(child_process).
			set process_state[0][3] to false. // redraw no longer needed
		}
		update_process(child_process).
		if process_finished(child_process){
			draw_outline(wnd).
			invalidate_process_window(process_state).
			set process_state[1] to "title_screen".
		}
	}
	

	set process_state[2] to abort.
	return -1.
}
