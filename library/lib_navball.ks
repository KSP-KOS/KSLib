// A library of functions to calculate navball-based directions:
@lazyglobal off.

// ---------
// east_for
// ---------
// Return the eastward unit vector of the vessel passed in.
function east_for {
  parameter ves.

  return vcrs(ves:up:vector, ves:north:vector).
}

// -------------
// compass_for
// -------------
// Return the compass heading in degrees [0..359.99999]
// of the vessel passed in.
function compass_for {
  parameter ves.

  local pointing is ves:facing:forevector.
  local east is east_for(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 { 
    return 360 + result.
  } else {
    return result.
  }
}

// ----------
// pitch_for
// ----------
// Return the pitch above horizon in degrees,
// of the vessel passed in.
// Will give positive values for pitch up, and negative
// values for pitch down.
function pitch_for {
  parameter ves.

  return 90 - vang(ves:up:vector, ves:facing:forevector).
}

// ---------
// roll_for
// ---------
// Return the roll in degrees, of the vessel passed in.
// Will register left-roll as positive and right-roll as negative.
function roll_for {
  parameter ves.

  return 90 - vang(ves:up:vector, ves:facing:starvector).
}.
