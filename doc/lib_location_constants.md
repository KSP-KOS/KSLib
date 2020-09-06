## `lib_location_constants`

The `lib_location_constants.ks` library provides geolocations for places that
would be relatively easy to locate for players flying manually (i.e., without
the use of scripting mods such as kOS). The locations in this file are not
authoritative; feel free to submit updates if you find them inaccurate.
Additions (new locations, including on bodies other than Kerbin or even
on non-stock bodies such as Earth or Gael) are welcome,
but you are advised to check with the KSLib developers (e.g., by submitting a
feature request) before adding locations of easter eggs that were originally
intended to be difficult to locate.

### Vertical landing locations

* `LocationConstants:launchpad`: the geolocation of the launchpad
* `LocationConstants:woomerang_launchpad`: the geolocation of the Woomerang
  launchpad (northern launchpad surrounded by mountains)
* `LocationConstants:dessert_launchpad`: alias for `desert_launchpad`
* `LocationConstants:desert_launchpad`: the launchpad in the Dessert Airfield
  location, which is in the middle of the desert.
* `LocationConstants:VAB`: the geolocation of the double helipad on top of the
  VAB. Don't land here if you care about the safety of your Kerbals at all
  (although the same could be said for playing KSP). Warning: landing here will
  **not** allow you to recover 100% funds.

### Runway naming convention

**tl;dr** `runway_start` is where airplanes normally spawn;
`reverse_runway_start` is where you want to land if you are heading west
(toward the mountains) instead of east.

For more details, consider the relevant
[Wikipedia passage](https://en.wikipedia.org/wiki/Runway#Runway_headings)
as of 6 Sept 2020:

>  A runway numbered 09 points east (90°), runway 18 is south (180°), runway 27 points west (270°) and runway 36 points to the north (360° rather than 0°). When taking off from or landing on runway 09, a plane is heading around 90° (east). A runway can normally be used in both directions, and is named for each direction separately: e.g., "runway 15" in one direction is "runway 33" when used in the other. The two numbers differ by 18 (= 180°).

### Horizontal landing locations

* `LocationConstants:dessert_runway_18_start`: alias for
  `desert_runway_18_start`
* `LocationConstants:desert_runway_18_start`: start of the desert runway when
  heading north. Roughly where planes spawn when "Dessert Airfield" is selected
  (only possible if you have the Making History DLC and have adjusted your
  difficulty settings to allow spawning in other sites).
* `LocationConstants:dessert_runway_36_start`: alias for
  `desert_runway_36_start`
* `LocationConstants:desert_runway_36_start`: start of the desert runway when
  heading south.
* `LocationConstants:island_runway_09_start`: start of the island runway when
  heading east. Warning: landing here will **not** allow you to recover 100%
  funds.
* `LocationConstants:island_runway_27_start`: start of the island runway when
  heading west. Warning: landing here will **not** allow you to recover 100%
  funds.
* `LocationConstants:l1_runway_09_start`: where the KSC runway starts when it
  has never been upgraded at all (still made of dirt).
* `LocationConstants:l1_runway_27_start`: start of the un-upgraded (dirt) runway
  when heading west.
* `LocationConstants:l2_runway_09_start`: where the KSC runway starts when
  upgraded once (paved, but with potholes and not lined with lights).
* `LocationConstants:l2_runway_27_start`: start of the partly upgraded
  (potholed) runway when heading west.
* `LocationConstants:runway_start`: alias for `runway_09_start`
* `LocationConstants:runway_09_start`: start of the fully upgraded KSC runway.
* `LocationConstants:reverse_runway_start`: alias for `runway_27_start`.
* `LocationConstants:runway_27_start`: start of the KSC runway when headed
  west (toward the mountains).
* `LocationConstants:runway_09_end`: The "lip" of the fully-upgraded KSC
  runway. Certain plane designs that can maintain level flight but cannot
  pitch up while landed should start pitching up when their wheels pass
  `runway_09_end`, since the lip will leave them airborne for a moment.
* `LocationConstants:runway_27_end`: The lip of the fully-upgraded KSC
  runway when headed toward the mountains. Mostly included for symmetry.
