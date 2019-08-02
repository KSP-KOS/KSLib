// This file is distributed under the terms of the MIT license, (c) the KSLib team
@LAZYGLOBAL OFF.

runPath("lib_navigation.ks").

local quit is false.
on AG10 {
    set quit to true.
}

local point is latlng(        // Target a random point
    (random() * 2 - 1) * 90,
    (random() * 2 - 1) * 180
).
set target to body("Minmus").

print "Activate action group 10 (0) to exit.".
print "We will print great circle heading".
print "for a random point and phase angle".
print "and angle to relative ascending node".
print "for Minmus.".
print "Great Circle Heading: ".
print "Phase angle to Minmus: ".
print "Angle to RAN for Minmus: ".
until quit {
    local line is 5.
    print greatCircleHeading(point) at (22, line).
    set line to line + 1.
    print phaseAngle() at (23, line).
    set line to line + 1.
    print angleToRelativeAscendingNode(orbitBinormal(), targetBinormal()) at (25, line). 
}
