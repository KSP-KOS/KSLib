// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_LAZcalc.

``lib_LAZcalc.ks`` provides the user with a launch azimuth based on a desired target orbit altitude and
inclination. It bases this calculation on the vessel's current geoposition.

args:
  * Desired circular target orbit altitude.
  * Desired target orbit inclination. Input a negative number if you want to launch from the descending
     node (a launch like this would take you on a heading *south* of 90 degrees)

returns:
  * A number.

description:
  * Returns the heading towards which the vessel should launch from its current geoposition in order to
     achieve the desired orbital inclination at the target circular orbit altitude.