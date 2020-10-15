// example_lib_num_to_str.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

run lib_num_to_str.
local num is 0.
clearscreen.

Print " ".
Print "+-----------------------+".
print "| Compass = -180.00 deg |".
print "+-----------------------+".
print " ".
print "Range is -180 to 180 to show the '-' indicator".
print " ".
Print "ag1 to exit.".

set ag1 to false.

until ag1 {
 set num to mod(-ship:bearing+180,360)-180.
 print num_to_str(num,3,2) at (12,2).
}.

set ag1 to false.
