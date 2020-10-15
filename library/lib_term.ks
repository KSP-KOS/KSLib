// lib_term.ks - terminal manipulations
// Copyright © 2015 KSLib team 
// Lic. MIT
// Original starting work by Github user: Dunbaratu

@lazyglobal off.

// -----------
// char_line
// -----------
// Perform a low level line drawing algorithm
// with characters on the terminal.
function char_line {
  parameter
    ch,             // string (character) to draw with.
    x0, y0, x1, y1. // locations to draw from/to

  local dX is x1-x0.
  local dY is y1-y0.
  local len is sqrt(dX^2+dY^2).
  local incSize is 2. // make loop only execute once if it's just a point.
  if len > 0 {
    set incSize to 1/len. // or let it execute a number of times if it's not.
  }
  local d is 0.
  until d > 1 {
    print ch at (d*dX+x0, d*dY+y0).
    set d to d + incSize.
  }.
}


// Draw an arc of an ellipse, using characters.
// Note that since the screen's Y axis goes bigger going
// DOWN, the result may be inverted from what you'd imagine.
function char_ellipse_arc {
  parameter
    ch,             // string (character) to draw with.
    x0, y0, xRad, yRad, deg0, deg1.

  // swap if arc degrees are given backward:
  if deg0 > deg1 { 
    local tmp is deg0.
    set deg0 to deg1.
    set deg1 to tmp.
  }.
  // incSize is the biggest number of degrees that is guaranteed
  // to be just barely small enough not to skip a character when drawing.
  local longRad is max(xRad,yRad).
  local incSize is arcsin(1/longRad).

  local d is deg0.
  until d > deg1 {
    print ch at (xRad*cos(d)+x0, yRad*sin(d)+y0).
    set d to d + incSize.
  }.
}.

// Draw a circle.  This is a special case of char_ellipse_arc.
function char_circle {
  parameter
    ch,
    x0, y0, r.
  char_ellipse_arc(ch, x0, y0, r, r, 0, 360).
}.
