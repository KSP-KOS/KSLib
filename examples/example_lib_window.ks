run lib_window_number_dialog.
run lib_window_vessel_stats.
run lib_window_menu.
run lib_process.

ag1 off.
set terminal:height to 40.
set terminal:width to 80.

function set_windows{
	clearscreen.
	set fraction to 0.5.//fraction of screen for left window
	set first_window_share to round((terminal:width-1)*fraction).
	set window1 to make_rect(0,0,
		first_window_share,terminal:height-2).
	set window2 to make_rect(window1[0]+window1[2]-1,0,
		terminal:width-window1[0]-window1[2]+1,terminal:height-2).
	draw_outline(window1).
	draw_outline(window2).
}

set_windows.

set all_proc to list().
all_proc:add(open_window_menu("Select stuff:",
	list("Argh","Nope","yelp"),window1)).
//all_proc:add(open_window_number_dialog("Apoapsis: ",100000,window1)).
all_proc:add(open_window_vessel_stats(window2)).

set old_terminal_width to terminal:width.
set old_terminal_height to terminal:height.
until false{
	update_all_processes(all_proc).
	if terminal:width<>old_terminal_width or
		terminal:height<>old_terminal_height{

		set_windows.

		change_process_window(all_proc[0],window1).
		change_process_window(all_proc[1],window2).

		set old_terminal_width to terminal:width.
		set old_terminal_height to terminal:height.
	}
}
