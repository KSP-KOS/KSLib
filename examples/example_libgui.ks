run lib_window_number_dialog.
run lib_window_vessel_stats.
run lib_window_menu.
run lib_window_akros_main_menu.
run lib_process.

// This is main file of akrOS, basic operating system developed by akrasuski1

ag1 off.
set terminal:height to 20.
set terminal:width to 60.

set list_of_windows to list(list(0,0,0,0),list(0,0,0,0)).

function set_windows{
	clearscreen.
	set fraction to 0.5.//fraction of screen for left window
	set first_window_share to round((terminal:width-1)*fraction).
	set list_of_windows[0][0] to 0.
	set list_of_windows[0][1] to 0.
	set list_of_windows[0][2] to first_window_share.
	set list_of_windows[0][3] to terminal:height-2.
	local window1 is list_of_windows[0].
	set list_of_windows[1][0] to window1[0]+window1[2]-1.
	set list_of_windows[1][1] to 0.
	set list_of_windows[1][2] to terminal:width-window1[0]-window1[2]+1.
	set list_of_windows[1][3] to terminal:height-2.


	for wnd in list_of_windows{
		draw_outline(wnd).
		draw_outline(wnd).
	}
}

set_windows.

set all_proc to list().
all_proc:add(open_window_akros_main_menu(list_of_windows,all_proc)).
//all_proc:add(open_window_number_dialog("Apoapsis: ",100000,window1)).
//all_proc:add(open_window_vessel_stats(list_of_windows[1])).

set old_terminal_width to terminal:width.
set old_terminal_height to terminal:height.
until all_proc:length=0{
	update_all_processes(all_proc).
	if terminal:width<>old_terminal_width or
		terminal:height<>old_terminal_height{

		set_windows.
		
		for proc in all_proc{
			invalidate_process_window(proc).
		}

		set old_terminal_width to terminal:width.
		set old_terminal_height to terminal:height.
	}
}

clearscreen.
