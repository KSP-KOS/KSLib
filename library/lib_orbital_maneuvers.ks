@lazyglobal off.

// This file contains a few functions that concentrate on creating
// maneuver nodes completing most common KSP tasks.

// This function creates a node (but doesn't place it) at time t, with
// specified delta-v vector.
function make_node_t_deltav{
	parameter
		t,
		dv.
	
	local pro_unit is velocityat(ship,t):orbit:normalized.
	local rad_unit is -VXCL(pro_unit,body:position-positionat(ship,t))
		:normalized.
	local nor_unit is VCRS(pro_unit,rad_unit).
	return node(t,rad_unit*dv,nor_unit*dv,pro_unit*dv).
}

// This function gets time as a parameter, and returns a maneuver
// node representing velocity change leading to circular orbit
// with that burn happening at specified time. If you want to 
// circularize at apoapsis, use: 
// circularize_at_time(time:seconds+eta:apoapsis).
function circularize_at_time{
	parameter t.

	local r is (body:position-positionat(ship,t)).
	local actual_vel is velocityat(ship,t):orbit.
	local expected_vel is VXCL(r,actual_vel):normalized*sqrt(body:mu/r:mag).
	local dv is expected_vel-actual_vel.
	return make_node_t_deltav(t,dv).
}

// This function gets two arguments: orbit and true anomaly in degrees
// and then returns time remaining until orbiting object will pass 
// through that true anomaly
function time_to_true_anomaly{
	parameter
		orb,
		a2.
	
	local e is orb:eccentricity.
	local a1 is orb:trueanomaly. // the current one
	local f is sqrt((1-e)/(1+e)).

	local e1 is 2*arctan(f*tan(a1/2)).
	local e2 is 2*arctan(f*tan(a2/2)).
	// e1 and e2 are eccentric anomalies at these times in degrees
	local m1 is constant():pi/180*e1-e*sin(e1).
	local m2 is constant():pi/180*e2-e*sin(e2).
	// m1 and m2 are mean anomalies at these times in radians
	local n is 2*constant():pi/orb:period.
	// n is mean angular velocity
	local t1 is m1/n.
	local t2 is m2/n.
	// t1 and t2 are times with regard to some, non-disclosed epoch,
	// at which orbitable will be at true anomaly a1 or a2 respectively
	local diff is t2-t1.
	if diff<0{ // ETA must be positive, so switch to next orbit
		set diff to orb:period+diff.
	}
	else if diff>orb:period{ // we can do one full orbit less
		set diff to diff-orb:period.
	}
	return diff.
}

// This function takes two orbits CONTAINED IN THE SAME PLANE and returns
// a list of at most three elements:
// - first one is a "status" - if it's equal to -1, then obt1 is fully
// contained within obt2, vice versa for +1. Otherwise, it is equal to
// 0 and the list contains two more elements
// - two other elements, existing only if orbits cross at some points,
// represent the time remaining until ship orbiting obt1 will pass common
// orbit point. This should be the point at which you would do the burn
// to randez-vous
function get_orbit_intersections{
	parameter
		obt1,
		obt2.

	local e1 is obt1:eccentricity.
	local e2 is obt2:eccentricity.
	local a1 is obt1:semimajoraxis.
	local a2 is obt2:semimajoraxis.
	local B is a1/a2*(1-e1*e1)/(1-e2*e2).
	local delta is obt2:argumentofperiapsis-obt1:argumentofperiapsis.
	local gamma is arctan2(e1-B*e2*cos(delta), -B*e2*sin(delta)).
	local S is (1-B)*cos(gamma)/B/e2/sin(delta).
	if S > 1-0.00001{
		return list(1).
	}
	else if S < -1+0.00001{
		return list(-1).
	}
	local beta1 is arcsin(S)-gamma.
	local beta2 is 180-arcsin(S)-gamma.
	return list(
		0, 
		time_to_true_anomaly(obt1,beta1),
		time_to_true_anomaly(obt1,beta2)
	).
}

// This function will put a randez-vous node at orbit intersection 
// between your orbit and tgt's orbit, if it exists. It assumes orbits
// share common plane.
function match_orbits{
	parameter tgt.
	
	local l is get_orbit_intersections(obt,tgt:obt).
	if l[0]<>0{
		return 0.
	}
	local t is l[1].
	if l[2]<t{
		set t to l[2].
	}

	local actual_vel is velocityat(ship,time:seconds+t):orbit.
	local intersection_r is body:position-positionat(ship,time:seconds+t).
	
	local tgt_r is body:position-tgt:position.
	local tgt_normal is VCRS(tgt:velocity:orbit,tgt_r).
	local side is VCRS(tgt_normal,tgt_r).
	local true_anomaly is VANG(intersection_r,tgt_r).
	if VDOT(side,intersection_r)<0{
		set true_anomaly to -true_anomaly.
	}
	set true_anomaly to true_anomaly+tgt:obt:trueanomaly.
	local t2 is time_to_true_anomaly(tgt:obt,true_anomaly).

	local expected_vel is velocityat(tgt,time:seconds+t2):orbit.
	return make_node_t_deltav(time:seconds+t,expected_vel-actual_vel).
}

// This function takes two identical orbits as arguments (though they
// differ in ship's current position). Function returns a node, that in
// N orbits (N is integer parameter) will match phase of both ships (put
// them in almost exact same place).
function match_orbital_phase{
	parameter
		orb1,
		orb2,
		n.
	
	local t1 is time_to_true_anomaly(orb1,0).
	local t2 is time_to_true_anomaly(orb2,0).
	
	local period is orb1:period.
	local dt is mod(t2-t1+period*1.5,period)-period/2.
	// now dt is time difference [-period/2,period/2] between target's
	// and my periapsis
	local h is 2*orb1:semimajoraxis*(1+dt/n/period)^(2/3)-
		orb1:periapsis-2*orb1:body:radius.
	return change_opposite_height(time:seconds+t1,h).
}

// This function returns a node that will at specified time raise or lower
// opposite orbit's side to specified height. If called at Pe, it will
// simply change Ap to specified height and vice versa.
function change_opposite_height{
	parameter
		t,
		height.
	
	local r is (body:position-positionat(ship,t)).
	local actual_vel is velocityat(ship,t):orbit.
	local expected_vel is VXCL(r,actual_vel):normalized*sqrt(
		2*body:mu*(height+body:radius)/r:mag/(r:mag+height+body:radius)
	).
	return make_node_t_deltav(t,expected_vel-actual_vel).
}

// This function rotates ship's orbit by burning normally at specified time
// BY given amomunt (not TO angle, but BY angle).
function change_inclination{
	parameter
		t,
		ang.
	
	local r is (body:position-positionat(ship,t)).
	local actual_vel is velocityat(ship,t):orbit.
	local normal_vel is VCRS(actual_vel,r):normalized*actual_vel:mag.
	return make_node_t_deltav(t,actual_vel*(cos(ang)-1)+normal_vel*sin(ang)).
}

// This function returns a maneuver node aligning orbital planes to
// orbitable passed as an argument.
function align_orbital_plane{
	parameter other.

	local my_r is (body:position-ship:position).
	local my_normal is VCRS(obt:velocity:orbit,my_r).
	
	local other_r is (body:position-other:position).
	local other_normal is VCRS(other:obt:velocity:orbit,other_r).

	local target_place is VCRS(my_normal,other_normal):normalized.
	local pe_place is positionat(ship,time:seconds+eta:periapsis)-body:position.
	local my_place is ship:position-body:position.

	local vel_at_pe is velocityat(ship,time:seconds+eta:periapsis):orbit.

	local true_anomaly is VANG(target_place,pe_place).
	if VDOT(target_place,vel_at_pe)<0{
		set true_anomaly to -true_anomaly.
	}
	local true_anomaly_of_me is VANG(my_place,pe_place).
	if VDOT(my_place,vel_at_pe)<0{
		set true_anomaly_of_me to -true_anomaly_of_me.
	}
	local diff is mod(true_anomaly-true_anomaly_of_me+360,360).
	if diff>180{
		set true_anomaly to true_anomaly-180.
		// switch descending to ascending node or vice versa to closer one
	}
	local t is time_to_true_anomaly(obt,true_anomaly).

	local inc is VANG(my_normal,other_normal).
	local vel_at_t is velocityat(ship,time:seconds+t):orbit.
	if VDOT(other_normal,vel_at_t)>0{
		set inc to -inc.
	}

	return change_inclination(time:seconds+t,inc).
}

// This function takes as argument an orbit and a height above ground.
// It returns a list of at most three elements:
// - first one is a status - if -1, then the orbit's apoapsis is too low,
// if +1, orbit's periapsis is too high, otherwise it's zero
// - the next two elements contain time remaining until orbiting object
// passes through specified height
function time_to_pass_height{
	parameter
		orb,
		h.
	
	set h to h+orb:body:radius.
	local e is orb:eccentricity.
	local p is orb:semimajoraxis*(1-e*e).
	if e=0{
		set e to 0.0000001.
	}
	local c is (h-p)/e/h.
	if c>1{
		return list(-1).
	}
	if c<-1{
		return list(1).
	}
	local theta is 180-arccos(c).
	return list(
		0,
		time_to_true_anomaly(orb,theta),
		time_to_true_anomaly(orb,-theta)
	).
}
