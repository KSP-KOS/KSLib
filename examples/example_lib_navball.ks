// example_lib_navball.ks tests the lib_navball functions.
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

run lib_navball.

clearscreen.

print "Testing lib_navball.".
print " ".
print " +-------------------------+".
print " | Compass ship =          |".
print " | Compass pro  =          |".
print " +-------------------------+".
print " ".
print " +-------------------------+".
print " | Pitch ship =            |".
print " | Pitch pro  =            |".
print " +-------------------------+".
print " ".
print " +-------------------------+".
print " |    Roll =               |".
print " +-------------------------+".
print " ".
print " +-------------------------+".
print " | Sideslip =              |".
print " +-------------------------+".
print " ".
print "Looping forever.  Use Action group 1 to break.".

set done to false.
on AG1 set done to true.

until done {
  local srfPro is compass_and_pitch_for(ship,srfprograde).
  print round(compass_for(ship), 1) + "    " at (18,3).
  print round(srfPro[0], 1)         + "    " at (18,4).
  print round(pitch_for(ship), 1)   + "    " at (16,8).
  print round(srfPro[1], 1)         + "    " at (16,9).
  print round(roll_for(ship), 1)    + "    " at (13,13).
  print round(bearing_between(ship,srfprograde,ship:facing),1)    + "    " at (14,17).
  wait 0.
}.
