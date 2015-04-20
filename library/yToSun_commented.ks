//The goal here is to get the ship's +Y axis pointing directly at the sun, by pitching down
//by 90 degrees from an (imaginary) start state of pointing at the sun with the ship's roll
//relative to the ecliptic being zero.

//I Discovered along the way, that even the vector Cross Product is left handed in KSP.


// This is the 'proper' way of doing it, that doesn't rely on the assumption that
// by default, roll goes to 0 when converting a vector to a direction.

//SET a TO V(0,1,0). //A vector pointing in the Raw +Y axis direction.
//SET b TO SUN:POSITION. //A vector pointing to the sun.
//SET rotAxis TO VCRS(a, b). //A vector (hopefully) pointing to the right as you look at the sun.
//SET startDir TO LOOKDIRUP(b, a). // A direction pointing to the sun, up oriented towards +Y(Raw).
//SET rotDir TO ANGLEAXIS(90, rotAXIS). // A direction that gives the required rotation (hopefully).
//SET finalDir TO rotDir * startDir. // The direction I want to be pointing in at the end

// This is the storage-optimised version. Here I use SUN:POSITION:DIRECTION to assume that
// The resultant direction will have zero roll relative to the ecliptic.
//SET a TO V(0,1,0). //A vector pointing in the Raw +Y axis direction.
//SET b TO SUN:POSITION. //A vector pointing to the sun.
//SET rotAxis TO VCRS(a, b). //A vector pointing to the right as you look at the sun.
//SET rotDir TO ANGLEAXIS(90, rotAXIS). // A direction that gives the required rotation.
//SET finalDir TO rotDir * SUN:POSITION:DIRECTION. // The direction/roll I want to be pointing in.

// This is the super-storage-optimised version, in one line, with no variables.

LOCK STEERING TO ANGLEAXIS(90, VCRS(V(0,1,0), SUN:POSITION)) * SUN:POSITION:DIRECTION.

WAIT UNTIL FALSE.