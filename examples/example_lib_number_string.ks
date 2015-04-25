// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_number_string.
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

until ag1 {
 set num to mod(-ship:bearing+180,360)-180.
 print numstring(num,3,2) at (12,2).
}.

set ag1 to false.
