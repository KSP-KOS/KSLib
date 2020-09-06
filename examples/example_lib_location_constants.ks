@LAZYGLOBAL off.

runpath("0:/KSLib/library/lib_location_constants").

// Compute the distance from the launch pad to the middle of the runway.

local launchpad to LocationConstants:launchpad:position.
local runway_start to LocationConstants:runway_09_start:position.
local runway_end to LocationConstants:runway_27_start:position.
local desired_distance to vxcl(runway_end - runway_start, launchpad - runway_start):mag.

print "The launch pad is " + round(desired_distance) + " meters from the" +
      " centerline of the runway.".
