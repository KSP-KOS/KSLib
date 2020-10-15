## lib_circle_nav.

``lib_circle_nav.ks`` provides a set of functions that use Great Circle equations. On the surface of a sphere the shortest path between 2 points does not have a constant bearing. Use of these functions either on their own or combined can give you all sorts of details about the "as the crow flies" path between 2 points. Including which way you need to go, how far it is and what you will fly over.


### circle_bearing

args:
  * A pair of ``GeoCoordinates``.
  
returns:
  * A number of degrees in the range [0..360].
  
description:
  * This equation will give you the initial bearing along the great circle path from point 1 to point 2.
Not overly useful when run once but by repeatedly running this with your current position as point 1 you will get a continuously updating bearing along the shortest path to point 2.

### circle_destination

args:
  * A initial location as a ``GeoCoordinates``.
  * An initial bearing as a number in degrees.
  * The distance from the initial location as a number in meters.
  * The radius of the sphere around which you are measuring. eg: ``SHIP:BODY:RADIUS``.
  
returns:
  * ``GeoCoordinates``
  
description:
  * This will tell you the ``GeoCoordinates`` of a point along a great circle path given a starting position, distance and initial bearing. It can be used for checking ``terrainheight`` up ahead. So no more crashing into that cliff because you can only track changes in terrain as you pass over it.

### circle_distance

args:
  * A pair of ``GeoCoordinates``.
  * The radius of the sphere around which you are measuring. eg: ``SHIP:BODY:RADIUS``.
   * Note: if you are flying at constant altitude ``SHIP:BODY:RADIUS + ALTITUDE`` will give you a more accurate result.

returns:
  * A distance in meters.
  
description:
  * kOS lets you query the distance to a latlng() position at the moment but it gives you the separation of the points in 3d space so if you ask for the distance to a point directly opposite you on Kerbin it will give tell you the distance is Kerbins diameter. This will give you the surface distance between 2 points. So will tell you the distance is half Kerbins circumference. This is useful if you want to know how far you will actually have to go and how long it will take you at your current surface speed.
It can also be used between a 2 arbitrary points not just your vessel's position and another so for lists of way-points you could use something like:
```
SET current To ship:geoposition.
SET distance TO 0.
FOR point IN waypoints {
 SET distance TO distance + circle_distance(current,point,body:radius).
 SET current TO point.
}.
PRINT distance.
```
to give the distance total distance of your current rout.

### circle_midpoint

args:
  * A pair of ``GeoCoordinates``.

returns:
 * ``GeoCoordinates``

description:
  * Gives you the midpoint between point 1 and 2 along a great circle path.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).