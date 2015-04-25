run lib_window_number_dialog.
run lib_window_vessel_stats.
run lib_window_menu.
run lib_process.

// this code shows two parallel windows on a screen, like this: [][]
// first one being number input dialog (no real reason why, just demonstrating)
// and the second one shows some vessel stats. Note that the stats update in background
// even while you select other number.

clearscreen.

set fraction to 0.5.//fraction of screen to left window
set first_window_share to round((terminal:width-3)*fraction).
set window1 to create_window(0,0,
	first_window_share,terminal:height-3).
set window2 to create_window(window1[0]+window1[2]+1,0,
	terminal:width-window1[0]-window1[2]-3,terminal:height-3).
// if you have just one window, just use:
// create_window(0,0,terminal:width-2,terminal:height-2)
// instead of those six lines

set all_proc to list().
//all_proc:add(open_window_menu("Select stuff:",
//	list("Argh","Nope","yelp"),window1)).
all_proc:add(open_window_number_dialog("Apoapsis: ",100000,window1)).
all_proc:add(open_window_vessel_stats(window2)).

set old_terminal_width to terminal:width.
set old_terminal_height to terminal:height.
until false{
	update_all_processes(all_proc).
	if terminal:width<>old_terminal_width or //this whole if is optional
		terminal:height<>old_terminal_height{//it's for resizing terminal
		clearscreen.
		set first_window_share to round((terminal:width-3)*fraction).
		set window1 to create_window(0,0,
			first_window_share,terminal:height-3).
		set window2 to create_window(window1[0]+window1[2]+1,0,
			terminal:width-window1[0]-window1[2]-3,terminal:height-3).
		set all_proc[0][0][1] to window1. //new resolution
		set all_proc[1][0][1] to window2. //new resolution
		set all_proc[0][0][3] to true. //please redraw
		set all_proc[1][0][3] to true. //please redraw

		set old_terminal_width to terminal:width.
		set old_terminal_height to terminal:height.
	}
}
