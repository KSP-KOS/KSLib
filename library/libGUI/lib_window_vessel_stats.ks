@lazyglobal off.

run lib_window.
run lib_navball.

function open_window_vessel_stats{
	parameter window.

	local process_state to list(
		list(false,window,"update_window_vessel_stats",false)
	).
	draw_window_vessel_stats(process_state).
	return process_state.
}

function draw_window_vessel_stats{
	parameter process_state.

	if not is_process_gui(process_state){
		return.
	}

	local window is get_process_window(process_state).

	print "Vessel stats:" at(window[0]+2,window[1]+2).
	print "Latitude: " at(window[0]+2,window[1]+4).
	print "Longitude: " at(window[0]+2,window[1]+5).
	print "Compass: " at(window[0]+2,window[1]+6).
	print "Mass: " at(window[0]+2,window[1]+7).
	print "Name: " at(window[0]+2,window[1]+8).
	print "Time: " at(window[0]+2,window[1]+9).
	print "SAS: " at(window[0]+2,window[1]+10).
	print "RCS: " at(window[0]+2,window[1]+11).
	print "GEAR: " at(window[0]+2,window[1]+12).
	print "LIGHTS: " at(window[0]+2,window[1]+13).
	print "PANELS: " at(window[0]+2,window[1]+14).
}

function bool_to_on_off{
	parameter bool.
	if bool{
		return "ON".
	}
	else{
		return "OFF".
	}
}

function update_window_vessel_stats{
	parameter process_state.

	if process_needs_redraw(process_state){
		draw_window_vessel_stats(process_state).
	}

	local wnd is get_process_window(process_state).
	print round(ship:geoposition:lat,5) at(wnd[0]+12,wnd[1]+4).
	print round(ship:geoposition:lng,5) at(wnd[0]+13,wnd[1]+5).
	print round(compass_for(ship),5)    at(wnd[0]+11,wnd[1]+6).
	print round(ship:mass,5)            at(wnd[0]+8, wnd[1]+7).
	print ship:name                     at(wnd[0]+8, wnd[1]+8).
	print time:clock                    at(wnd[0]+8, wnd[1]+9).
	print bool_to_on_off(sas)           at(wnd[0]+7, wnd[1]+10).
	print bool_to_on_off(rcs)           at(wnd[0]+7, wnd[1]+11).
	print bool_to_on_off(gear)          at(wnd[0]+8, wnd[1]+12).
	print bool_to_on_off(lights)        at(wnd[0]+10,wnd[1]+13).
	print bool_to_on_off(panels)        at(wnd[0]+10,wnd[1]+14).
	return -1.
}
