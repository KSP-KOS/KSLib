// example_testsasmode.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

clearscreen.
set oldsas to sas.
sas on.
set delay to 4.
print("testing sasmode").
wait delay.
set sasmode to "prograde".
print "prograde check!".
wait delay.
selectautopilotmode("retrograde").
print "retrograde check!".
wait delay.
set sasmode to "normal".
print "normal check!".
wait delay.
set sasmode to "antinormal".
print "antinormal check!".
wait delay.
set sasmode to "radialin".
print "radialin check!".
wait delay.
set sasmode to "RadialOut".
print "RadialOut check!".
wait delay.
add node(time:seconds + 60, 0, 0, 1000).
set sasmode to "maneuver".
print "maneuver check!".
wait delay.
set sasmode to "target".
print "target check!".
wait delay.
set sasmode to "antitarget".
print "antitarget check!".
wait delay.
