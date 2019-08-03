// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_navigation

`lib_navigation.ks` provides a plethora of useful functions to aid in writing navigational scripts, whether it's space navigation or surface navigation.

### orbitTangent
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital velocity ves.

### orbitBinormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital angular momentum of ves.

### orbitNormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both orbitTangent and orbitBinormal in a left handed system.

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
  * Returns a unit vector in the direction of surface velocity of ves.

### surfaceBinormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of surface angular momentum of ves.

### surfaceNormal
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both surfaceTangent and surfaceBinormal in a left handed system.

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
  * Returns the angle to the ascending node of ves with respect to the ves' body's equator.

### angleToBodyDescendingNode
args:
  * ves: `Orbitable` defaults to `ship`

returns:
  * `Scalar`

description:
  * Returns the angle to the descending node of ves with respect to the ves' body's equator.

### angleToRelativeAscendingNode
args:
  * orbitBinormal: `Vector` representing your orbital angular momentum
  * targetBinormal: `Vector` representing target's orbital angular momentum

returns:
  * `Scalar`

description:
  * Returns the angle to the relative ascending node calculated from the args.

### angleToRelativeDescendingNode
args:
  * orbitBinormal: `Vector` representing your orbital angular momentum
  * targetBinormal: `Vector` representing target's orbital angular momentum

returns:
  * `Scalar`

description:
  * Returns the angle to the relative descending node calculated from the args.

### phaseAngle
returns:
  * `Scalar`

description:
  * Assumes a `target` is set. Returns the phase angle between `SHIP` and `TARGET` with respect to the common parent body. It is positive when you're behind in the orbit, and negative when ahead.

### greatCircleHeading
args:
  * point: One of `GeoCoordinates`, `Waypoint`, `Vessel`

returns:
  * `Scalar`

description:
  * Returns the instantaneous heading required to go from current position to point's position along the great circle joining the two positions.

### burnTime
args:
  * deltaV: One of `Scalar`, `Vector`

returns:
  * `Scalar`

description:
  * Returns the amount of time required to get `deltaV` from active engines. Does not consider fuel requirements.
