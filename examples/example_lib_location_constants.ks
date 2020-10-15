// example_lib_location_constants.ks 
// Copyright © 2020 KSLib team 
// Lic. MIT

@LAZYGLOBAL off.

runpath("lib_location_constants.ks").

// Compute the distance from the launch pad to the middle of the runway.

local launchpad to location_constants:kerbin:launchpad:position.
local runway_start to location_constants:kerbin:runway_09_start:position.
local runway_end to location_constants:kerbin:runway_09_end:position.
local desired_distance to vxcl(runway_end - runway_start, launchpad - runway_start):mag.

print "The launch pad is " + round(desired_distance) + " meters from the" +
      " centerline of the runway.".
