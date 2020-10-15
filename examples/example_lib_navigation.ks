// example_lib_navigation.ks 
// Copyright © 2019 KSLib team 
// Lic. MIT
@LAZYGLOBAL OFF.

runPath("lib_navigation.ks").

local quit is false.
on AG10 {
    set quit to true.
}

set target to body("Minmus").

print "Activate action group 10 (0) to exit.".
print "We will print angle to".
print "relative ascending node for Minmus".
print "Phase angle to Minmus: ".
print "Angle to RAN for Minmus: ".
until quit {
    local line is 3.
    print phaseAngle() at (23, line).
    set line to line + 1.
    print angleToRelativeAscendingNode(
        orbitBinormal(ship),
        orbitBinormal(target)
    ) at (25, line). 
}
