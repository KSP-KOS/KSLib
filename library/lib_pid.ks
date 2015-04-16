// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

function PID_init {
  parameter
    Kp, // gain of position
    Ki, // gain of integral
    Kd. // gain of derivative

  local SeekP is 0. // desired value for P (will get set later).
  local P is 0.     // phenomenon P being affected.
  local I is 0.     // crude approximation of Integral of P.
  local D is 0.     // crude approximation of Derivative of P.
  local oldT is -1. // (old time) start value flags the fact that it hasn't been calculated
  local oldInput is 0. // previous return value of PID controller.

  // Because we don't have proper user structures in kOS (yet?)
  // I'll store the PID tracking values in a list like so:
  //
  local PID_array is list().
  PID_array:add(Kp).    // [0]
  PID_array:add(Ki).    // [1]
  PID_array:add(Kd).    // [2]
  PID_array:add(SeekP). // [3]
  PID_array:add(P).     // [4]
  PID_array:add(I).     // [5]
  PID_array:add(D).     // [6]
  PID_array:add(oldT).  // [7]
  PID_array:add(oldInput). // [8].

  return PID_array.
}.

function PID_seek {
  parameter
    PID_array, // array built with PID_init.
    seekVal,   // value we want.
    curVal.    // value we currently have.

  // Using LIST() as a poor-man's struct.

  local Kp   is PID_array[0].
  local Ki   is PID_array[1].
  local Kd   is PID_array[2].
  local oldS is PID_array[3]. 
  local oldP is PID_array[4].
  local oldI is PID_array[5].
  local oldD is PID_array[6].
  local oldT is PID_array[7]. // Old Time
  local oldInput is PID_array[8]. // prev return value, just in case we have to do nothing and return it again.

  local P is seekVal - curVal.
  local D is 0. // default if we do no work this time.
  local I is 0. // default if we do no work this time.
  local newInput is oldInput. // default if we do no work this time.

  local t is time:seconds.
  local dT is t - oldT.

  if oldT < 0 {
    // I have never been called yet - so don't trust any
    // of the settings yet.
  } else {
    if dT = 0 { // Do nothing if no physics tick has passed from prev call to now.
      set newInput to oldInput.
    } else {
      set D to (P - oldP)/dT. // crude fake derivative of P
      set I to oldI + P*dT. // crude fake integral of P
      set newInput to Kp*P + Ki*I + Kd*D.
    }.
  }.

  // remember old values for next time.
  set PID_array[3] to seekVal.
  set PID_array[4] to P.
  set PID_array[5] to I.
  set PID_array[6] to D.
  set PID_array[7] to t.
  set PID_array[8] to newInput.

  return newInput.
}.
