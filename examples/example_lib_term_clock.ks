// example_lib_term_clock.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT
// Original starting work by Github user: Dunbaratu

// Example that uses some of the lib_term line drawing
// routines to make a Kerbal clock showing the current
// kerbin time.
//
// Designed to show off the circle and line drawing primitives
// of lib_term.

run lib_term.
clearscreen.


// Change these to fiddle with
// where it appears and how big it is:
set centerX to 17.
set centerY to 17.
set clockRadius to 15.

// Draw the clock face:
// -------------------
char_circle(":", centerX, centerY, clockRadius).

// Draw the 6 Hour markers:
set h to 0.
set rad to clockRadius.
until h > 5 {
  print "*" at (centerX+rad*cos(60*h-90), centerY+rad*sin(60*h-90)).
  set h to h + 1.
}.
set h to 0.
set rad to clockRadius+1.
until h > 5 {
  print h at (centerX+rad*cos(60*h-90), centerY+rad*sin(60*h-90)).
  set h to h + 1.
}.

// Label the clock:
print "Kerbin Clock"     at (centerX+clockRadius+2, centerY-clockRadius).
print "Watch the hands." at (centerX+clockRadius+2, 2+centerY-clockRadius).
print "Use time warp "   at (centerX+clockRadius+2, 4+centerY-clockRadius).
print "to see it move "  at (centerX+clockRadius+2, 5+centerY-clockRadius).
print "faster."          at (centerX+clockRadius+2, 6+centerY-clockRadius).
print "Ctrl-C to quit."  at (centerX+clockRadius+2, 8+centerY-clockRadius).

// Loop forever, drawing the hands.
until false {
  set h to time:hour + (time:minute/60).
  set m to time:minute.
  set s to time:second.

  // Draw hands in current position:
  drawHand( "H", centerX, centerY, 60*h, 2, clockRadius*2/3).
  drawHand( "M", centerX, centerY, 6*m, 1, clockRadius*7/8).
  drawHand( "s", centerX, centerY, 6*s, 0, clockRadius*7/8).

  // allow 1 second to pass:
  set ts to time:seconds.
  wait until time:seconds > ts+1.

  // Erase hands in current position:
  drawHand( " ", centerX, centerY, 60*h, 2, clockRadius*2/3).
  drawHand( " ", centerX, centerY, 6*m, 1, clockRadius*7/8).
  drawHand( " ", centerX, centerY, 6*s, 0, clockRadius*7/8).
}.

function drawHand {
  parameter
    ch,   // char to draw with.
    x0,   // center x coord.
    y0,   // center y coord.
    deg,  // degrees where it is now on the clock (0 = straight up)
    width, // width start the hand line.
    rMax. // max radius to stop the hand line.

  local px1 is rMax*(cos(deg-90))+x0.
  local py1 is rMax*(sin(deg-90))+y0.
  local px0 is width*(cos(deg-180))+x0.
  local py0 is width*(sin(deg-180))+y0.
  local px2 is width*(cos(deg))+x0.
  local py2 is width*(sin(deg))+y0.
  char_line( ch, px0, py0, px1, py1).
  char_line( ch, px1, py1, px2, py2).
  char_line( ch, px2, py2, px0, py0).
}.
