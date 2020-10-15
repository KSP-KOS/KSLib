## lib_LAZcalc.

``lib_LAZcalc.ks`` provides the user with a launch azimuth based on a desired target orbit altitude and
inclination and can continued to be used throughout ascent to update the heading. It bases this calculation on the vessel's launch and current geoposition.

## LAZcalc_init()

args:
  * Desired circular target orbit altitude *in meters*. **Note:** Versions 2.0 and prior had the input altitude in kilometers
  * Desired target orbit inclination.
    * Input a negative number if you want to launch from the descending node (a launch like this would take you on a heading *south* of 90 degrees)
    * After launch, the north/south selection is updated automatically based on your ship's velocity. If your velocity vector has a northward component, `LAZcalc()` will return a northerly heading, and vice versa.
  * (Optional) Tolerance in meters per second for auto north/south switching. The north/south component of your velocity vector must be at least this large to override the stored north/south selection. Default is 10 m/s. Pass zero to disable automatic switching (for instance, if you need to run azimuth calculations for future use).

**Note:** If the inclination input is impossible to reach from the ship's current latitude, the script will attempt to determine whether the user is seeking an easterly or westerly launch and then will correct the input inclination to allow for the lowest (easterly) or highest (westerly) inclination possible.

returns:
  * A list.

description:
  * Returns a list to be used by the `LAZcalc` function containing all the relevant calculations that can or need to be performed from the launch site.

## LAZcalc()

args:
  * The list returned by `LAZcalc_init`.

returns:
  * A number.

description:
  * Returns the heading (0 to 360) towards which the vessel should launch from its current geoposition in order to
    achieve the desired orbital inclination at the target circular orbit altitude.
  * To use:
    * First `SET `[stored data]` TO LAZcalc_init(`[target orbit]`,`[target inclination]`.`
    * Then loop `SET `[heading]` TO LAZcalc(`[stored data]`).` to continuously update your target heading.

---
Copyright © 2015,2017,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).