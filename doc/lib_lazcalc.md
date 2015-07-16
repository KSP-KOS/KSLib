// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_LAZcalc.

``lib_LAZcalc.ks`` provides the user with a launch azimuth based on a desired target orbit altitude and
inclination and can contunued to be used throughout accent to update the heading. It bases this calculation on the vessel's launch and current geoposition.

## LAZcalc_init()

args:
  * Desired circular target orbit altitude *in kilometers*.
  * Desired target orbit inclination. Input a negative number if you want to launch from the descendingnode (a launch like this would take you on a heading *south* of 90 degrees)
**Note:** If the inclination input is impossible to reach from the ship's current latitude, the script will attempt to determine whether the user is seeking an easterly or westerly launch and then will correct the input inclination to allow for the lowest (easterly) or highest (westerly) inclination possible.

returns:
  * A a list.

description:
  * Returns a list to be used by the `LAZcalc` function containing all the relivent calcualtions that can or need to be performed from the launch site.

## LAZcalc()

args:
  * The list returned by `LAZcalc_init`.

returns:
  * A number.

description:
  * Returns the heading (0 to 360) towards which the vessel should launch from its current geoposition in order to
    achieve the desired orbital inclination at the target circular orbit altitude.
  * To use:
   *First `SET `[stored data]` TO LAZcalc_init(`[target orbit]`,`[target inclination]`.`
   *Then loop `SET `[heading]` TO LAZcalc(`[stored data]`).` to continuously update your target heading.
