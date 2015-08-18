 //http://forum.kerbalspaceprogram.com/threads/68089-1-0-4-kOS-Scriptable-Autopilot-System-v0-17-3-2015-6-27/page336?p=2080376#post2080376

 set ag9 to false.
 run lib_lift_drag.ks.

 clearscreen.

 set drag   to vecdrawargs(v(0,0,0),v(0,0,0),red,  "drag"  ,1,True).
 set thrust to vecdrawargs(v(0,0,0),v(0,0,0),red,  "thrust",1,True).
 set lift   to vecdrawargs(v(0,0,0),v(0,0,0),blue, "lift"  ,1,True).
 set grav   to vecdrawargs(v(0,0,0),v(0,0,0),green,"grav"  ,1,True).
 set accel   to vecdrawargs(v(0,0,0),v(0,0,0),green,"accel"  ,1,True).

set scale to 0.3/ship:mass.
set drag:scale to scale.
set thrust:scale to scale.
set lift:scale to scale.
set grav:scale to scale.
set accel:scale to scale.


set vecOffset to v(0,-10,0) / scale.
set lift:start to vecOffset.
set grav:start to vecOffset.
set drag:start to vecOffset.
set thrust:start to vecOffset.
set accel:start to vecOffset + V(1,0,0).

 print "Drag:        "  at (0,1).
 print "Thrs:        "  at (0,2).
 print "Lift:        "  at (0,3).
 print "Grav:        "  at (0,4).
 print "Accl(sensor):"  at (0,6).
 print "Accl(vel):   "  at (0,7).

 local lift_drag_array is init_lift_drag().


 until ag9 {
  set vec to lift_drag(lift_drag_array).
  set lift:vec to vxcl(ship:srfprograde:vector,vec) .
  set drag:vec to vdot(vec,ship:srfprograde:vector)*ship:srfprograde:vector.

  set thrust:vec to thrustCalc()*ship:facing:vector.
  set grav:vec   to gravity().

  set acc to compute_acceleration(lift_drag_array).
  set accel:vec   to acc.

  print round(drag:vec:mag,2)   +" kN     " at (9,1).
  print round(thrust:vec:mag,2) +" kN     " at (9,2).
  print round(lift:vec:mag,5)   +" kN     " at (9,3).
  print round(grav:vec:mag,5)   +" kN     " at (9,4).

  print round(ship:sensors:acc:mag/9.82,2)   +" g     " at (15,6).
  print round(acc:mag/9.82,2)   +" g     " at (15,7).




  print lift_drag_array[0] at (10,15).
  print lift_drag_array[1] at (10,16).

 }.
 set ag9 to false.

 set lift:show to false.
 set drag:show to false.
 set thrust:show to false.
 set grav:show to false.

print "End".
