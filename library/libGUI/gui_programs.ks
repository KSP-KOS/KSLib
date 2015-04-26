@lazyglobal off.

run lib_window_vessel_stats.

//this file defines which programs you want to have on your OS.

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
