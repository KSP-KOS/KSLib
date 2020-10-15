## lib_navball.

``lib_navball.ks`` provides useful routines to obtain information about
a vessel's orientation in a navball-centric way.

### east_for

args:
  1) an optional argument defaulted to ``SHIP``, must be of type: Vessel.

returns:
  * a vector.

description:
  * Returns the eastward vector of the ship's current location, to
    complete the three axes (the mod only provides SHIP:UP and
    SHIP:NORTH at the moment).

### compass_for

args:
  1) an optional argument defaulted to ``SHIP``, must be of type: Vessel.
  2) an optional argument defaulted to ``arg1:facing:vector``, can be a vector, direction, vessel, part, geoposition, or waypoint.
    * if not a vector will arg_2 will be converted into a vector by the function ``type_to_vector``

returns:
  * a number of degrees in the range [0..360]

description:
  * Returns the compass heading of arg_2 as measured from the vessel defined by arg_1.

### pitch_for

args:
  1) an optional argument defaulted to ``SHIP``, must be of type: Vessel.
  2) an optional argument defaulted to ``arg1:facing:vector``, can be a vector, direction, vessel, part, geoposition, or waypoint.
    * if not a vector arg_2 will be converted into a vector by the function ``type_to_vector``

returns:
  * a number of degrees in the range [-90..90]

description:
  * Returns the pitch above the horizon as measured from the vessel defined by arg_1 of arg_2.
    Pitching up gets a positive number, Pitching down a negative number.

### roll_for

args:
  1) an optional argument defaulted to ``SHIP``, must be of type: Vessel.
  2) an optional argument defaulted to ``arg1:facing``, can be a direction, vessel, or part.
    * if a vessel or part will be turned into a direction using ``:facing``

returns:
  * a number of degrees in the range [-180..180]

description:
  * Returns the roll relative to the horizon of arg_2's "top" vector.
    Left roll gets a positive number, right roll a negative number.

### compass_and_pitch_for

args:
  1) an optional argument defaulted to ``SHIP``, must be of type: Vessel, such as ``SHIP``.
  2) an optional argument defaulted to ``arg1:facing:vector``, can be a vector, direction, vessel, part, geoposition, or waypoint.
    * if not a vector arg_2 will be converted into a vector by the function ``type_to_vector``

returns:
  * a list with 2 items, a number of degrees in the range [0..360], a number of degrees in the range [-90..90]

description:
  * Returns the a list of 2 items the first being the compass heading, and the second being the pitch.
    The compass heading and pitch are calculated for arg2 from the perspective of the vessel passed in as arg1.

### bearing_between

args:
  1) a Vessel, such as ``SHIP``.
  2) can be a vector, direction, vessel,part, geoposition, or waypoint.
    * if not a vector arg_2 will be converted into a vector by the function ``type_to_vector``
  3) can be a vector, direction, vessel,part, geoposition, or waypoint.
    * if not a vector arg_3 will be converted into a vector by the function ``type_to_vector``

returns:
  *  a number of degrees in the range [-180..180]

description:
  * Returns the relative heading of arg_3, with arg_2 treated as north, with the horizon defined by arg_1.
    Will be positive if arg_3 is to the "east" of arg_2, and negative if arg_3 is to the "west" of arg_2


### type_to_vector

args:
  1) a Vessel, such as ``SHIP``.
  2) the type to be converted can be a vector, direction, vessel, part, geoposition, or waypoint.

returns:
  * if arg_2 is of type "vector", will return the vector normalized.
  * if arg_2 is of type "direction", will return ``arg2:vector``.
  * if arg_2 is of type "vessel" or "part", will return ``arg2:facing:vector``.
  * if arg_2 is of type "geoposition", will return the normalized vector pointing from the position of arg_1 to the position of the geoposition.
  * if not of the above types, will return the passed in arg_2.

description
  * Will convert several types into vectors.
    Intended for internal use by the functions of this library.

---
Copyright © 2015,2019,2020 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).