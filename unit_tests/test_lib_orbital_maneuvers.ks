run lib_orbital_maneuvers.

// Run this test while being in an orbit, preferably eccentric to
// test many scenarios. Note that there should not be an encounter
// or escape on current orbit.

function print_unit_test_result{
	parameter result.

	local str is "FAIL".
	if result{
		set str to "PASS".
	}
	print "+============+".
	print "|TEST "+str+"ED.|".
	print "+============+".
}

function om_unit_test1{
	// This test tries to circularize at many different points of the orbit.
	local i is 0.
	local result is true.
	until i>obt:period{
		local nd is circularize_at_time(time:seconds+i).
		add nd.
		local deviation is round(nd:orbit:apoapsis-nd:orbit:periapsis,1).
		print "Deviation="+deviation+"m".
		if deviation>100{ // a reasonable margin
			set result to false.
			break.
		}
		wait 0.01.
		remove nd.
		set i to i+obt:period/100.
	}
	print_unit_test_result(result).
	return result.
}

function om_unit_test2{
	// This test will try to predict ETA:periapsis and ETA:apoapsis via
	// time_to_true_anomaly
	local result is true.
	local deviation is ETA:periapsis-time_to_true_anomaly(obt,0).
	print "Deviation: "+round(deviation,2)+"s".
	if abs(deviation)>5{
		set result to false.
	}
	local deviation is ETA:apoapsis-time_to_true_anomaly(obt,180).
	print "Deviation: "+round(deviation,2)+"s".
	if abs(deviation)>5{
		set result to false.
	}
	// Note that this test might fail even though it works correctly, if
	// you are very close to Pe or Ap, so that ETA fluctuates between 0
	// and obt:period.
	print_unit_test_result(result).
	return result.
}

function om_unit_test3{
	// This test will try to set its periapsis at exactly 30km at different
	// positions in orbit.
	local i is 0.
	local result is true.
	until i>obt:period{
		local nd is change_opposite_height(time:seconds+i,30000).
		add nd.
		local deviation is round(nd:orbit:periapsis-30000,1).
		print "Deviation="+deviation+"m".
		if abs(deviation)>5{ // a reasonable margin
			set result to false.
			break.
		}
		wait 0.01.
		remove nd.
		set i to i+obt:period/100.
	}
	print_unit_test_result(result).
	return result.
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

	if abs(obt:period-nd:orbit:period)>10{ // 10s of margin
		print "Maneuver changed orbital period.".
		set result to false.
	}
	print "Angle between normals: "+VANG(expected_normal,minmus_normal).
	if VANG(expected_normal,minmus_normal)>2{ // two degrees of margin
		print "Maneuver did not place at the same plane.".
		set result to false.
	}
	if nd:eta>obt:period/2+20{
		print "Maneuver was set at wrong inclination node.".
		set result to false.
	}
	wait 1.
	remove nd.
	print_unit_test_result(result).
	return result.
}

function om_unit_test5{
	local result is true.
	local ap is obt:apoapsis.
	local pe is obt:periapsis.
	local res is time_to_pass_height(obt,pe-1000).
	if res[0]<>1{
		print "Found a moment when height=periapsis-1000".
		set result to false.
	}
	local res is time_to_pass_height(obt,ap+1000).
	if res[0]<>-1{
		print "Found a moment when height=apoapsis+1000".
		set result to false.
	}

	local res is time_to_pass_height(obt,(ap+pe)/2).
	if res[0]<>0{
		print "Haven't found a moment when height=SMA".
		set result to false.
	}
	local res is time_to_pass_height(obt,pe+1).
	if res[0]<>0{
		print "Haven't found a moment when height=pe+1m".
		set result to false.
	}
	else{
		// This test may give false positive depending on eccentricity
		// of your orbit. Try to test using eccentricity > 0.1
		local deviation is abs(res[1]-res[2]).
		print "Deviation="+deviation+"s".
		if deviation>obt:period/100{
			print "Two moments were too far separated".
			set result to false.
		}
	}
	print_unit_test_result(result).
	return result.
}

function om_unit_tests{
	local overall is true.
	if not om_unit_test1(){
		set overall to false.
	}
	wait 1.
	if not om_unit_test2(){
		set overall to false.
	}
	wait 1.
	if not om_unit_test3(){
		set overall to false.
	}
	wait 1.
	if not om_unit_test4(){
		set overall to false.
	}
	wait 1.
	if not om_unit_test5(){
		set overall to false.
	}
	wait 1.
	print " ".
	print "OVERALL RESULT:".
	if overall{
		print "ALL TESTS PASSED SUCCESSFULLY".
	}
	else{
		print "SOME TESTS FAILED".
	}
}

om_unit_tests().
