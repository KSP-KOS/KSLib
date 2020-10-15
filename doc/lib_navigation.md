## lib_navigation

`lib_navigation.ks` provides a plethora of useful functions to aid in writing navigational scripts, whether it's space navigation or surface navigation.

### orbitTangent
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital velocity of ves. Typically same as Prograde in KSP.

### orbitBinormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital angular momentum of ves. Typically same as Normal in KSP.

### orbitNormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both orbitTangent and orbitBinormal in a left handed system. Typically same as Radial In in KSP.

### orbitLAN
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector along the line joining descending and ascending node, pointed towards the ascending node.

### surfaceTangent
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of surface velocity of ves. Typically same as surface Prograde in KSP.

### surfaceBinormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of surface angular momentum of ves. Typically same as surface Normal in KSP.

### surfaceNormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both surfaceTangent and surfaceBinormal in a left handed system. Typically same as surface Radial In in KSP.

### surfaceLAN
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector along the line joining descending and ascending node, pointed towards the ascending node.

### localVertical
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a vector pointing directly away from the body of ves at ves' position.

### angleToBodyAscendingNode
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Scalar`

description:
  * Returns the angle to the ascending node of ves with respect to the ves' body's equator. Positive if the node is ahead of you, negative otherwise.

### angleToBodyDescendingNode
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Scalar`

description:
  * Returns the angle to the descending node of ves with respect to the ves' body's equator. Positive if the node is ahead of you, negative otherwise.

### angleToRelativeAscendingNode
args:
  * orbitBinormal: `Vector` representing your orbital angular momentum
  * targetBinormal: `Vector` representing target's orbital angular momentum

returns:
  * `Scalar`

description:
  * Returns the angle to the relative ascending node calculated from the args. Positive if the node is ahead of you, negative otherwise.

### angleToRelativeDescendingNode
args:
  * orbitBinormal: `Vector` representing your orbital angular momentum
  * targetBinormal: `Vector` representing target's orbital angular momentum

returns:
  * `Scalar`

description:
  * Returns the angle to the relative descending node calculated from the args. Positive if the node is ahead of you, negative otherwise.

### phaseAngle
returns:
  * `Scalar`

description:
  * Assumes a `target` is set. Returns the phase angle between `SHIP` and `TARGET` with respect to the common parent body. It is positive when you're behind in the orbit, and negative when ahead.

### _avg_isp
returns:
  * `Scalar`

description:
  * Returns the average specific impulse of the active engines or -1 if no active engine is detected. Although the function can be used by the end user, it is meant primarily for internal calculations.

### getBurnTime
args:
  * deltaV: One of `Scalar`, `Vector`
  * isp: `Scalar` defaults to 0

returns:
  * `Scalar`

description:
  * Returns the amount of time required to get `deltaV` from active engines, -1 if no active engine is present. Does not consider fuel requirements. Calculation is done using the average specific impulse (arg `isp`) or calculates the Isp if left at the default.

### azimuth
args:
  * inclination: `Scalar` target inclination
  * orbit_alt: `Scalar` target orbital altitude
  * auto_switch: `Boolean` whether to automatically switch between northward/southward azimuth

returns:
  * `Scalar`

description:
  * Returns the azimuth (navball heading) required to launch to inclined orbit, taking into consideration current orbital velocity. If `auto_switch` is set, the function will check the ship's proximity with ascending and descending node to return a northward or southward azimuth, respectively.

---
Copyright © 2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).