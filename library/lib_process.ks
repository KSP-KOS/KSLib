@lazyglobal off.

run lib_exec.

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
	return evaluate(process[0][2]+"(__process_state)").
	//TODO: update above line when new lib_exec comes
}

function update_all_processes{
	parameter process_list.
	local i is 0.
	until i=process_list:length(){
		local proc is process_list[i].
		update_process(proc).
		if proc[0][0]=true{ //finished
			process_list:remove(i).
			if proc[0][1]:length()>0{
				local wnd to proc[0][1].
				create_window(wnd[0],wnd[1],wnd[2],wnd[3]).
			}
		}
		else{
			set i to i+1.
		}
	}
}
