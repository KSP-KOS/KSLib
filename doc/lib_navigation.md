// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_navigation

`lib_navigation.ks` provides a plethora of useful functions to aid in writing navigational scripts, whether it's space navigation or surface navigation.

### orbitTangent
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital velocity

### orbitBinormal
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of orbital angular momentum

### orbitNormal
returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both orbitTangent and orbitBinormal in a left handed system.

### orbitLAN
returns:
  * `Vector`

description:
  * Returns a unit vector along the line joining descending and ascending node, pointed towards the ascending node.

### surfaceTangent
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of surface velocity

### surfaceBinormal
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of surface angular momentum

### surfaceNormal
returns:
  * `Vector`

description:
  * Returns a unit vector that is perpendicular to both surfaceTangent and surfaceBinormal in a left handed system.

### surfaceLAN
returns:
  * `Vector`

description:
  * Returns a unit vector along the line joining descending and ascending node, pointed towards the ascending node.

### localVertical
returns:
  * `Vector`

description:
  * Returns a vector pointing directly away from the current body at current position.

### targetTangent
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of target's orbital velocity. Assumes target is set.

### targetBinormal
returns:
  * `Vector`

description:
  * Returns a unit vector in the direction of target's orbital angular momentum. Assumes target is set.

### targetNormal
returns:
  * `Vector`

description:
  * Returns a unit vector perpendicular to both targetTangent and targetBinormal. Assumes target is set.

### targetLAN
returns:
  * `Vector`

description:
  * Returns a unit vector along the line joining the target's descending and ascending node, pointed towards the ascending node. Assumes target is set.

### angleToBodyAscendingNode
returns:
  * `Scalar`

description:
  * Returns the angle to the ascending node with respect to the current body's equator.

### angleToBodyDescendingNode
returns:
  * `Scalar`

description:
  * Returns the angle to the descending node with respect to the current body's equator.

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
  * Assumes a target is set. Returns the phase angle between `SHIP` and `TARGET` with respect to the common parent body. It is positive when you're behind in the orbit, and negative when ahead.

### greatCircleHeading
args:
  * point: One of `GeoCoordinates`, `Waypoint`, `Vessel`

returns:
  * `Scalar`

description:
  * Returns the instantaneous heading required to go from current position to point's position along the great circle joining the two positions.
