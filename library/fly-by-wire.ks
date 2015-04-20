// Copied from Camacha's post on the forums

clearscreen.
print "Fly-by-wire-o-tronic 1.0".
print "Written by Camacha".
print "Status: running...".

//hitting abort ends program
abort off.

stage.

//sets analogue stick sensitivity, range 0-200
set sens to 75.

list engines in englist.
set engine_0 to englist[0].
set engine_1 to englist[1].
set engine_2 to englist[2].
set engine_3 to englist[3].

until abort=true {

//for keyboard control use alternate line instead: set maintrot to ship:control:pilotmainthrottle * 100.
//when using a keyboard, remember to set throttle to 0 before running script

	set maintrot to (ship:control:pilotmainthrottle - 0.5) * 200.

	set engine_0:thrustlimit to maintrot + (ship:control:pilotroll * sens).
	set engine_1:thrustlimit to maintrot + (ship:control:pilotpitch * sens).
	set engine_2:thrustlimit to maintrot + ((ship:control:pilotroll * -1) * sens).
	set engine_3:thrustlimit to maintrot + ((ship:control:pilotpitch * -1) * sens).
}.

clearscreen.