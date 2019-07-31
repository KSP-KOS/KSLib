// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_geodec.

`lib_geodec.ks` provides two functions to convert between geographic coordinates (latitude, longitude) and cartesian coordinates (x, y, z). The origin of the cartesian coordinates is at the center of the body, the positive x axis is directed to (0, 0) latitude and longitude. The positive z axis is directed to the south pole. As such the coordinate system is left handed.

### geo2dec

args:
  * latitude, scalar
  * longitude, scalar
  * altitude, scalar

returns:
  * a list of 3 items.

description:
  * Converts the geocoordinates and altitude into cartesian coordinates. The 3 items of the return list are to be interpreted as (x, y, z) coordinates, in that order.

### dec2geo

args:
  * x, scalar
  * y, scalar
  * z, scalar

returns:
  * a list of 3 items.

description:
  * Converts the cartesian coordinates into geocoordinates and altitude. The 3 items of the return list are to be interpreted as latitude, longitude and altitude, in that order.
