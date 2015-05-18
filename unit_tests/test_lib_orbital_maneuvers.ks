@lazyglobal off.

run lib_orbital_maneuvers.
run lib_exec.

// Please run this test while being in an orbit around Kerbin, which has
// Pe>30km (which is any stable orbit), Ap<30Mm (inside Mun's orbit is 
// enough). Preferably, to test weird scenarios, make your orbit
// inclined and eccentric.

function om_unit_test1{
	// This test tries to circularize at many different points of the orbit.
	local i is 0.
	until i>obt:period{
		local nd is circularize_at_time(time:seconds+i).
		add nd.
		local deviation is round(nd:orbit:apoapsis-nd:orbit:periapsis,1).
		if deviation>100{ // a reasonable margin
			return "Orbit was not circularized - (Ap-Pe)="+deviation+"m>100m".
		}
		wait 0.01.
		remove nd.
		set i to i+obt:period/100.
	}
	return "".
}

function om_unit_test2{
	// This test will try to predict ETA:periapsis and ETA:apoapsis via
	// time_to_true_anomaly
	local deviation is ETA:periapsis-time_to_true_anomaly(obt,0).
	if abs(deviation)>5{
		return "Difference between ETA:periapsis and time predicted by"+
			"library is "+deviation+"s>5s".
	}
	local deviation is ETA:apoapsis-time_to_true_anomaly(obt,180).
	if abs(deviation)>5{
		return "Difference between ETA:apoapsis and time predicted by"+
			"library is "+deviation+"s>5s".
	}
	// Note that this test might fail even though it works correctly, if
	// you are very close to Pe or Ap, so that ETA fluctuates between 0
	// and obt:period.
	return "".
}

function om_unit_test3{
	// This test will try to set its periapsis at exactly 30km at different
	// positions in orbit.
	local i is 0.
	until i>obt:period{
		local nd is change_opposite_height(time:seconds+i,30000).
		add nd.
		local deviation is round(nd:orbit:periapsis-30000,1).
		if abs(deviation)>5{ // a reasonable margin
			return "The script tried to set its periapsis at 30km, but"+
				" instead set it at "+nd:orbit:periapsis/1000+"km".
		}
		wait 0.01.
		remove nd.
		set i to i+obt:period/100.
	}
	local i is 0.
	until i>obt:period{
		local nd is change_opposite_height(time:seconds+i,30000000).
		add nd.
		local deviation is round(nd:orbit:apoapsis-30000000,1).
		if abs(deviation)>1000{ // a reasonable margin
			return "The script tried to set its periapsis at 30Mm, but"+
				" instead set it at "+nd:orbit:apoapsis/1000000+"Mm".
		}
		wait 0.01.
		remove nd.
		set i to i+obt:period/100.
	}
	return "".
}

function om_unit_test4{
	local result is true.
	set target to body("Minmus").
	local nd is align_orbital_plane(target).
	add nd.
	local minmus_vel is target:velocity:orbit.
	local minmus_pos is target:position-body:position.
	local minmus_normal is VCRS(minmus_vel,minmus_pos).

	local expected_vel is nd:orbit:velocity:orbit.
	local expected_pos is nd:orbit:position-body:position.
	local expected_normal is VCRS(expected_vel,expected_pos).

	local vel_before_burn is velocityat(ship,nd:eta):orbit.
	
	local deviation is abs(obt:period-nd:orbit:period).
	if deviation>10{ // 10s of margin
		return "Plane switch maneuver changed orbital period (deviation="+
			deviation+"s)".
	}
	local ang is VANG(expected_normal,minmus_normal).
	if ang>2{ // two degrees of margin
		return "Plane switch maneuver did not place at the same plane - "+
			"deviation of planes is "+ang+" degrees, which is more than 2.".
	}
	if nd:eta>obt:period/2+20{
		return "Plane switch maneuver was set at wrong inclination node.".
	}
	wait 1.
	remove nd.
	return "".
}

function om_unit_test5{
	local result is true.
	local ap is obt:apoapsis.
	local pe is obt:periapsis.
	local res is time_to_pass_height(obt,pe-1000).
	if res[0]<>1{
		return "Found a moment when height=periapsis-1000 (impossible)".
	}
	local res is time_to_pass_height(obt,ap+1000).
	if res[0]<>-1{
		return "Found a moment when height=apoapsis+1000 (impossible)".
	}

	local res is time_to_pass_height(obt,(ap+pe)/2).
	if res[0]<>0{
		return "Haven't found a moment when height=SMA".
	}
	local res is time_to_pass_height(obt,pe+1).
	if res[0]<>0{
		return "Haven't found a moment when height=Pe+1m".
	}
	else{
		// This test may give false positive depending on eccentricity
		// of your orbit. Try to test using eccentricity > 0.1
		local deviation is abs(res[1]-res[2]).
		if deviation>obt:period/100{
			return "Two moments when height=Pe+1m were too separated"+
				" in time ("+deviation+"s)".
		}
	}
	return "".
}

function om_unit_tests{
	local fail_reason is "".
	local res is "".
	local i is 1.
	until i>5{
		set res to evaluate("om_unit_test"+i+"()").
		if res<>""{
			set fail_reason to res.
			break.
		}
		wait 1.
		set i to i+1.
	}

	print " ".
	print "Overall result:".
	if fail_reason=""{
		print "All tests passed SUCCESSFULLY".
	}
	else{
		print "Some tests FAILED".
		print "Reasone of the first FAIL:".
		print "".
		print fail_reason.
	}
	print " ".
}

om_unit_tests().
