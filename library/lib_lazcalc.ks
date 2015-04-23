//=====LAUNCH AZIMUTH CALCULATOR=====
//~~LIB_LAZcalc.ks~~
//~~Version 1.0~~

//To use: RUN LAZcalc.ks. SET myLaunchAzimuth TO LAZcalc([desired circular orbit altitude in kilometers],[desired orbital inclination; negative if launching from descending node, positive otherwise])

@LAZYGLOBAL OFF.

FUNCTION LAZcalc {

	//#open Variable Declaration
	
	DECLARE PARAMETER desiredAlt.		//Altitude of desired target orbit (circular)
	DECLARE PARAMETER desiredInc.		//Inclination of desired target orbit

	LOCAL launchNode TO "A".		//Whether the launch should be at the ascending or descending node. Defaults to ascending.
	LOCAL inertialAzimuth TO -1.		//Launch azimuth before taking into account the rotation of the planet
	LOCAL launchAzimuth TO -1.			//Launch azimuth after taking into account the rotation of the planet
	LOCAL targetOrbVel TO -1.			//Orbital velocity of the desired target orbit
	LOCAL targetOrbSMA TO -1.			//Semi-major axis of the desired target orbit
	LOCAL equatorialVel TO -1.			//Velocity of the planet's equator
	LOCAL VXRot TO -1.
	LOCAL VYRot TO -1.

	//#close Variable Declaration

	//#open Input Sterilization

	//Orbital altitude can't be less than sea level
	IF desiredAlt <= 0 {
		SET desiredAlt to 100.
	}.

	//Orbital inclination can't be less than launch latitude or greater than 180
	IF ABS(desiredInc) < ABS(SHIP:LATITUDE) OR ABS(desiredInc) > (180 - SHIP:LATITUDE) {
		SET desiredInc TO SHIP:LATITUDE.
	}.
	
	IF desiredInc < 0 {
		SET launchNode TO "D".
		SET desiredInc TO ABS(desiredInc).
	}.

	//#close Input Sterilization

	//#open Calculations

	SET desiredAlt TO desiredAlt * 1000.		//Converts to kilometers
	SET targetOrbSMA TO desiredAlt + BODY:RADIUS.
	SET targetOrbVel TO SQRT(BODY:MU / (targetOrbSMA)).
	SET equatorialVel TO (2 * CONSTANT():PI * BODY:RADIUS) / BODY:ROTATIONPERIOD.
	SET inertialAzimuth TO ARCSIN(COS(desiredInc) / COS(SHIP:LATITUDE)).
	SET VXRot TO (targetOrbVel * SIN(inertialAzimuth)) - (equatorialVel * COS(SHIP:LATITUDE)).
	SET VYRot TO (targetOrbVel * COS(inertialAzimuth)).
	SET launchAzimuth TO ARCTAN(VXRot / VYRot).

	//#close Calculations

	//#open Output

	IF launchNode = "D" {
		SET launchAzimuth TO 180 - launchAzimuth.
	}.
	
	RETURN launchAzimuth.

	//#close Output

}. //FUNCTION LAZcalc