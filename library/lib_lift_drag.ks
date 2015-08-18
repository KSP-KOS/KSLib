// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

// Script limitations:
// 1- needs an accelerometer (science part) sticked to the vessel (best placed near the )
// 2- assumes no engine has gimballing
// 3- everything that isn't either gravity or thrust will account as either drag or lift
//      including RCS, torque and vibrations


function lift_drag {
 parameter lastSample.

 local M is ship:mass.
 local a is compute_acceleration(lastSample).
  //local a is ship:sensors:acc.
 local grav is -(body:mu/(body:radius+ship:altitude)^2)*up:vector. // negavive magnitude to up vector is down.

 local thrust is 0.     // calculated by queriying the engines
 local fuel_flow is 0.// calculated by queriying the engines
 local eng_list is list().
 list engines in eng_list.
 for eng in eng_list {
  set thrust to thrust+eng:thrust.
 }.
 local resultant is M * ( a - grav )  - thrust * ship:facing:vector.

 print (compute_acceleration(lastSample)-ship:sensors:acc) + " doff"  at (2,20).
 print (ship:sensors:acc) + "   sensor"  at (2,21).
 print (compute_acceleration(lastSample)) + " cpmite"  at (2,22).

 return resultant.
}.


function gravity {

  local grav is -(body:mu/(body:radius+ship:altitude)^2)*up:vector. // negavive magnitude to up vector is down.

  return grav * ship:mass.
}.

function thrustCalc {
  local thrust is 0.     // calculated by queriying the engines

  local eng_list is list().
  list engines in eng_list.

  for eng in eng_list {
   set thrust to thrust+eng:thrust.
  }.

  return thrust.

}.

function listEngines {
  local eng_list is list().
  list engines in eng_list.

}.

function init_lift_drag {
  local lift_drag_array is list(time:seconds,velocity:surface,V(0,0,0)).

  return lift_drag_array.
}.

function compute_acceleration {
  parameter lastSample.

 local dt to TIME:seconds-lastSample[0].

 if dt > 0 {
   local dv to velocity:surface - lastSample[1].

   local acc to dv/dt. // do I need more digits for g?

   print round(dt,5)   +" dt     " at (7,9).
   print round(dv:mag,5)   +" dv     " at (7,10).
   print round(acc:mag,5)   +" g     " at (7,11).
   print acc  +" acc     " at (7,12).

   set lastSample[0] to TIME:seconds.
   set lastSample[1] to velocity:surface.
   set lastSample[2] to acc.
 } else {
   set acc to lastSample[2].
 }

 return acc.

}.
