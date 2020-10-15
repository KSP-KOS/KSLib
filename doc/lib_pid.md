## Notice:
  lib_pid.ks has been superseded by the kOS inbuilt PIDloop() function.
  It is maintained for example purposes only, please see the kOS documentation for more.

## lib_pid

A library of routines to implement a simple generic PID controller.

### PID_init

args:
  * Kp - number, the tuning gain for the Proportional (position) term.
  * Ki - number, the tuning gain for the Integral term.
  * Kd - number, the tuning gain for the Derivative term.
  * cMin - number, the bottom limit of the control range (to protect against integral windup)
  * cMax - number, the upper limit of the control range (to protect against integral windup)

returns:
  * PID_array - a data structure holding info to be passed to PID_seek.

description:
  * Initialize a PID controller data structure to hold the
    values used later during calls to PID_seek, given the
    initial tuning parameters.  This is a very simple PID controller
    that makes no attempts to tune its parameters.  You must supply them
    for it.  Call PID_init once before your controlling loop begins.
  * When calling it, set cMin and cMax to define the range of valid values
    it should be allowed to return for the control input.  For example if
    using it for a LOCK THROTTLE, you should set cMin to 0 and cMax to 1.
    if using it for, say, a SHIP:CONTROL:YAW, it should be a cMin of -1
    and a cMax of +1.

### PID_seek

args:
  * PID_array - the structure returned by an earlier call to PID_init
  * seekVal - number, the value you are trying to seek, the "setpoint".
  * curVal - number, the value of the thing you are seeking, as it
    currently measures right now

returns:
  * newInput - number, the value you should be setting the
    input controlling mechanism to.

description:
  * After PID_init has been called, you call PID_seek repeatedly in a
    loop, telling it the value of some property you are trying to
    seek, and the value that property currently has.  It will return
    a number back to you that you should immediately set the control
    that influences that property to.  An example showing it being
    used exists in the examples directory, to create a hovering rocket.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).