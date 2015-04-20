clearscreen.

//the following are all vectors, mainly for use in the roll, pitch, and angle of attack calculations

lock rightrotation to ship:facing*r(0,90,0).
lock right to rightrotation:vector. //right and left are directly along wings
lock left to (-1)*right.
lock up to ship:up:vector. //up and down are skyward and groundward
lock down to (-1)*up.
lock fore to ship:facing:vector. //fore and aft point to the nose and tail
lock aft to (-1)*fore.
lock righthor to vcrs(up,fore). //right and left horizons
lock lefthor to (-1)*righthor.
lock forehor to vcrs(righthor,up). //forward and backward horizons
lock afthor to (-1)*forehor.
lock top to vcrs(fore,right). //above the cockpit, through the floor
lock bottom to (-1)*top.

//the following are all angles, useful for control programs

lock absaoa to vang(fore,srfprograde:vector). //absolute angle of attack
lock aoa to vang(top,srfprograde:vector)-90. //pitch component of angle of attack
lock sideslip to vang(right,srfprograde:vector)-90. //yaw component of aoa
lock rollangle to vang(right,righthor)*((90-vang(top,righthor))/abs(90-vang(top,righthor))). //roll angle, 0 at level flight
lock pitchangle to vang(fore,forehor)*((90-vang(fore,up))/abs(90-vang(fore,up))). //pitch angle, 0 at level flight
lock glideslope to vang(srfprograde:vector,forehor)*((90-vang(srfprograde:vector,up))/abs(90-vang(srfprograde:vector,up))).

//display some of the info. It's nice to just fly around with this on to get a sense for what's what.

until false {
print "ALL VALUES ARE IN DEGREES" at (5,4).
print "Roll Angle: "+floor(rollangle)+" " at (5,5).
print "Pitch Angle: "+floor(pitchangle)+" " at (5,6).
print "Angle of Attack: "+floor(absaoa)+" " at (5,7).
print "Pitch Component of Angle of Attack: "+floor(aoa)+" " at (5,8).
print "Sideslip: "+floor(sideslip)+" " at (5,9).
print "Glide Slope: "+floor(glideslope)+" " at (5,10).
}.