@lazyglobal off.

run lib_window.
run lib_navball.

function open_window_vessel_stats{
	parameter window.

	local process_state to list(
		list(false,window,"update_window_vessel_stats",false)
	).
	redraw_window_vessel_stats(process_state).
	return process_state.
}

function redraw_window_vessel_stats{
	parameter process_state.

	local window is process_state[0][1].

	print "Vessel stats: (AG1 closes)" at(window[0]+2,window[1]+2).
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

function update_window_vessel_stats{
	parameter process_state.

	if process_state[0][3]{
		redraw_window_vessel_stats(process_state).
	}

	local wnd is process_state[0][1].
	if ag1{
		set process_state[0][0] to true. //finished
		return 0.
	}
	local sason is "OFF".
	if sas{
		set sason to "ON ".
	}
	local rcson is "OFF".
	if rcs{
		set rcson to "ON ".
	}
	local gearon is "OFF".
	if gear{
		set gearon to "ON ".
	}
	local lightson is "OFF".
	if lights{
		set lightson to "ON ".
	}
	local panelson is "OFF".
	if panels{
		set panelson to "ON ".
	}
	print round(ship:geoposition:lat,5) at(wnd[0]+12,wnd[1]+4).
	print round(ship:geoposition:lng,5) at(wnd[0]+13,wnd[1]+5).
	print round(compass_for(ship),5)    at(wnd[0]+11,wnd[1]+6).
	print round(ship:mass,5)            at(wnd[0]+8, wnd[1]+7).
	print ship:name                     at(wnd[0]+8, wnd[1]+8).
	print time:clock                    at(wnd[0]+8, wnd[1]+9).
	print sason                         at(wnd[0]+7, wnd[1]+10).
	print rcson                         at(wnd[0]+7, wnd[1]+11).
	print gearon                        at(wnd[0]+8, wnd[1]+12).
	print lightson                      at(wnd[0]+10, wnd[1]+13).
	print panelson                      at(wnd[0]+10, wnd[1]+14).
	return -1.
}
