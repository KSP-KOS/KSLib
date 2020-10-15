// example_lib_pid.ks 
// Copyright © 2015,2016 KSLib team 
// Lic. MIT
clearscreen.
SAS on.
set seekAlt to 25.

print "A simple test of libPID.".
print "Does a hover script at " + seekAlt + "m AGL.".
print " ".
print "  Try flying around with WASD while it hovers.".
print "  (steering is unlocked. under your control.".
print " ".
print "  Keys:".
print "     Action Group 1 : -10 hover altitude".
print "     Action Group 2 :  -1 hover altitude".
print "     Action Group 3 :  +1 hover altitude".
print "     Action Group 4 : +10 hover altitude".
print "     LANDING LEGS   : Deploy to exit script".
print " ".
print " Seek ALT:RADAR = ".
print "  Cur ALT:RADAR = ".
print " ".
print "       Throttle = ".
print " ".
print " ".
print " ".
print "lib_pid.ks has been superseded by the kOS".
print "inbuilt PIDloop() function.".
print "It is maintained for example purposes only,".
print "please see the kOS documentation for more.".

// load the functions I'm using:
run lib_PID.

on ag1 { set seekAlt to seekAlt -10. preserve. }.
on ag2 { set seekAlt to seekAlt - 1. preserve. }.
on ag3 { set seekAlt to seekAlt + 1. preserve. }.
on ag4 { set seekAlt to seekAlt +10. preserve. }.

set ship:control:pilotmainthrottle to 0.

// hit "stage" until there's an active engine:
until ship:availablethrust > 0 {
  wait 0.5.
  stage.
}.

// Call to update the display of numbers:
function display_block {
  parameter startCol, startRow. // define where the block of text should be positioned

  print round(seekAlt,2) + "m    " at (startCol,startRow).
  print round(alt:radar,2) + "m    " at (startCol,startRow+1).
  print round(myth,3) + "      " at (startCol,startRow+3).
}.

// thOffset is how far off from midThrottle to be.
// It's the value I'll be letting the PID controller
// adjust for me.
set myTh to 0.

lock throttle to myTh.

set hoverPID to PID_init( 0.05, 0.01, 0.1, 0, 1 ). // Kp, Ki, Kd, min, max control  range vals.

gear on.  gear off. // on then off because of the weird KSP 'have to hit g twice' bug.

until gear {
  set myTh to PID_seek( hoverPID, seekAlt, alt:radar ).
  display_block(18,13).
  wait 0.001.
}.

set ship:control:pilotmainthrottle to throttle.
print "------------------------------".
print "Releasing control back to you.".
print "------------------------------".

