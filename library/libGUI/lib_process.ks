@lazyglobal off.

run lib_exec.

function process_finished{
	parameter process.
	return process[0][0].
}

function get_process_window{
	parameter process.
	return process[0][1].
}

function get_process_update_function{
	parameter process.
	return process[0][2].
}

function process_needs_redraw{
	parameter process.
	return process[0][3].
}

function end_process{
	parameter process.
	set process[0][0] to true.
}

function is_process_gui{
	parameter process.
	return process[0][1]:length>0.
}

function change_process_window{
	parameter process.
	parameter window.

	set process[0][1] to window.
	set process[0][3] to true.
}

function update_process{
	parameter process.
	//process is a struct (list) containing process system info
	//and, as a second element, process internal variables list.
	//System info:
	//[0] - Process_finished (bool)
	//[1] - Display_window (struct) - if non-gui, empty list
	//[2] - Update_function (string)
	//[3] - Please_redraw (bool)
	global __process_state is process.
	return evaluate(
		get_process_update_function(process)+"(__process_state)"
	).
	//TODO: update above line when new lib_exec comes
}

function update_all_processes{
	parameter process_list.
	local i is 0.
	until i=process_list:length(){
		local proc is process_list[i].
		update_process(proc).
		if process_finished(proc){
			process_list:remove(i).
			if is_process_gui(proc){
				draw_outline(get_process_window(proc)).
			}
		}
		else{
			set i to i+1.
		}
	}
}
