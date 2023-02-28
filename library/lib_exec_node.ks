@lazyglobal off.

// This file is currently just a placeholder for a more robust version,
// uploaded solely because it is a very basic function for KSP.
// I would be glad if anyone helps to develop it (add staging,
// perhaps improve burntime calculations, add special cases such
// as not enough fuel, etc.)

function MaxShipThrust{ 
	// this function is needed as a workaround
	// to kOS bug regarding ship thrust.
	local engs is list().
	list engines in engs.
	local mth is 0.
	for eng in engs{
		if eng:VISP > 0 {
			set mth to mth + eng:MAXTHRUST.
		}
	}
	return mth.
}

function exec_node{
	parameter nd.
	
	local mth is MaxShipThrust().
	lock burntime to nd:deltav:mag/(mth/mass).

	lock steering to nd.
	wait until nd:eta<burntime/2.
	local timeout is time:seconds+max(burntime*2,100). // just a guess

	lock throttle to cos(vang(nd:deltav,ship:facing:vector)).
	// Thanks to cosine, we burn only when we face the correct direction.

	wait until burntime<5 or time:seconds>timeout. 
	// last 5 seconds of burn should be slower
	local scale is nd:deltav:mag.

	lock throttle to nd:deltav:mag/scale*
		cos(vang(nd:deltav,ship:facing:vector)).
	// We burn slower and slower.
	
	local timeout is time:seconds+100.
	wait until nd:deltav:mag<scale*0.01 or time:seconds>timeout.
	lock throttle to 0.

	unlock throttle.
	unlock steering.
}
