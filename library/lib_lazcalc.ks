//=====LAUNCH AZIMUTH CALCULATOR=====
//~~LIB_LAZcalc.ks~~
//~~Version 1.1~~

//To use: RUN LAZcalc.ks. SET myLaunchAzimuth TO LAZcalc([desired circular orbit altitude in kilometers],[desired orbital inclination; negative if launching from descending node, positive otherwise])

@LAZYGLOBAL OFF.

FUNCTION LAZcalc_init {
 PARAMETER
  desiredAlt, //Altitude of desired target orbit (in meters)
  desiredInc. //Inclination of desired target orbit
  
 LOCAL struct IS LIST().   // A list is used to store information used by LAZcalc

 //#open Input Sterilization
 
 //Converts kilometers to meters (coment out to input in meters).
 set desiredAlt to desiredAlt*1000.
 
 //Orbital altitude can't be less than sea level
 IF desiredAlt <= 0 {
	PRINT "Target altitude cannot be below sea level".
	SET launchAzimuth TO 1/0.		//Throws error
 }.

 //Orbital inclination can't be less than launch latitude or greater than 180 - launch latitude
 if abs(ship:geoposition:lat) > abs(desiredInc) {
  set inc to ship:geoposition:lat*(desiredInc/abs(desiredInc)).
 	HUDTEXT("Inclination impossible from current latitude, setting for closest possible inclination.", 10, 2, 30, RED, FALSE).
 }.
 
 //#close Input Sterilization
 
 //Does all the one time calculations and stores them in a list to help reduce the overhead or continuously updating
 LOCAL launchLatitude IS SHIP:LATITUDE.
 LOCAL equatorialVel IS (2 * CONSTANT():Pi * BODY:RADIUS) / BODY:ROTATIONPERIOD.
 LOCAL targetOrbVel IS SQRT(BODY:MU/ (BODY:RADIUS + desiredAlt)).
 struct:ADD(desiredInc).     //[0]
 struct:ADD(launchLatitude). //[1]
 struct:ADD(equatorialVel).  //[2]
 struct:ADD(targetOrbVel).   //[3]
 RETURN struct.
}.

function LAZcalc {
 PARAMETER
  struct. //pointer to the list created by LAZcalc_init
 LOCAL inertialAzimuth IS ARCSIN(COS(struct[0])/COS(SHIP:LATITUDE)).
 LOCAL VXRot IS struct[3]*SIN(inertialAzimuth)-struct[2]*COS(struct[1]).
 LOCAL VYRot IS struct[3]*COS(inertialAzimuth).
 LOCAL Azimuth IS ARCTAN2(VXRot,VYRot).

 // This clamps the result to values between 0 and 360.
 RETURN MOD(Azimuth+360,360).
}.
