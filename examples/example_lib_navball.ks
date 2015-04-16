// Testing the lib_navball functions.

run lib_navball.

clearscreen.

print "Testing lib_navball.".
print " ".
print " +--------------------+".
print " | Compass =          |".
print " +--------------------+".
print " ".
print " +--------------------+".
print " |   Pitch =          |".
print " +--------------------+".
print " ".
print " +--------------------+".
print " |    Roll =          |".
print " +--------------------+".
print " ".
print "Looping forever.  Use Action group 1 to break.".

set done to false.
on AG1 set done to true.

until done {
  print round(compass_for(ship), 1) + "    " at (13,3).
  print round(pitch_for(ship), 1)   + "    " at (13,7).
  print round(roll_for(ship), 1)    + "    " at (13,11).
  wait 0.
}.
