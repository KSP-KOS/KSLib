// example_lib_geodec.ks 
// Copyright © 2019 KSLib team 
// Lic. MIT
@LAZYGLOBAL off.

runPath("lib_geodec.ks").

clearScreen.

print "Testing lib_geodec.".
print "Use Action Group 0 to end the script.".

local done is false.
on AG10 {
    set done to true.
}

print "x: " at (0, 2).
print "y: " at (0, 3).
print "z: " at (0, 4).
print "GeoCoordinates of a point 1000 m ahead" at (0, 5).
print "in x direction of ship:" at (0, 6).
print "Lat: " at (0, 7).
print "Lng: " at (0, 8).
print "Alt: " at (0, 9).

until done {
    local xyz is geo2dec(
        ship:latitude,
        ship:longitude,
        ship:altitude
    ).
    local latlon is dec2geo(
        xyz[0] + 1000,
        xyz[1],
        xyz[2]
    ).
    print round(xyz[0], 2) + " m" at (3, 2).
    print round(xyz[1], 2) + " m" at (3, 3).
    print round(xyz[2], 2) + " m" at (3, 4).
    print round(latlon[0], 2) + " deg" at (5, 7).
    print round(latlon[1], 2) + " deg" at (5, 8).
    print round(latlon[2], 2) + " m" at (5, 9).
    wait 0.
}
