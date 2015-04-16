// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_navball.

``lib_navball.ks`` provides useful routines to obtain information about
a vessel's orientation in a navbal-centric way.

### east_for

args:
  a Vessel, such as ``SHIP``.
returns:
  a vector.
description:
  Returns the eastward vector of the ship's current location, to
  complete the three axes (the mod only provides SHIP:UP and
  SHIP:NORTH at the moment).

### compass_for

args:
  a Vessel, such as ``SHIP``.
returns:
  a number of degrees in the range [0..360)
description:
  Returns the compass heading of the given vessel's nose.

### pitch_for

args:
  a Vessel, such as ``SHIP``.
returns:
  a number of degrees in the range [-90..90]
description:
  Returns the pitch above the horizon for the vessel's nose.
  Pitching up gets a positive number, Pitching down a negative number.

### roll_for

args:
  a Vessel, such as ``SHIP``.
returns:
  a number of degrees in the range [-180..180]
description:
  Returns the roll relative to the horizon for the vessel's "top".
  Left roll gets a positive number, right roll a negative number.
