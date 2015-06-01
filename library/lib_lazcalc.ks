//=====LAUNCH AZIMUTH CALCULATOR=====
//~~LIB_LAZcalc.ks~~
//~~Version 1.0~~
//This file is distributed under the terms of the MIT license, (c) the KSLib team
//Authored by space_is_hard


//To use: RUN LAZcalc.ks. SET myLaunchAzimuth TO LAZcalc([desired circular orbit altitude in kilometers],[desired orbital inclination; negative if launching from descending node, positive otherwise])

@LAZYGLOBAL OFF.

FUNCTION LAZcalc {

	//#open Variable Declaration
	
	DECLARE PARAMETER desiredAlt.		//Altitude of desired target orbit (circular)
	DECLARE PARAMETER desiredInc.		//Inclination of desired target orbit

	LOCAL launchNode TO "A".		//Whether the launch should be at the ascending or descending node. Defaults to ascending.
	LOCAL currentLatitude TO SHIP:LATITUDE.		//Pulls the current latitude to avoid having a slightly different latitude used for different parts of the calculation due to them occuring in different physics ticks
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
		PRINT "Target altitude cannot be below sea level".
		SET launchAzimuth TO 1/0.		//Throws error
	}.

	//Orbital inclination can't be less than launch latitude or greater than 180 - launch latitude
	IF ABS(desiredInc) < ABS(currentLatitude) {
		SET desiredInc TO ABS(currentLatitude).
		HUDTEXT("Inclination impossible from current latitude, setting inclination to latitude, eastward launch", 10, 2, 30, RED, FALSE).
		
	} ELSE IF ABS(desiredInc) > (180 - ABS(currentLatitude)) {
		SET desiredInc TO (180 - ABS(currentLatitude)).
		HUDTEXT("Inclination impossible from current latitude, setting inclination to latitude, westward launch", 10, 2, 30, RED, FALSE).
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
	SET inertialAzimuth TO ARCSIN(COS(desiredInc) / COS(currentLatitude)).
	SET VXRot TO (targetOrbVel * SIN(inertialAzimuth)) - (equatorialVel * COS(currentLatitude)).
	SET VYRot TO (targetOrbVel * COS(inertialAzimuth)).
	SET launchAzimuth TO ARCTAN(VXRot / VYRot).

	//#close Calculations

	//#open Output

	IF launchNode = "D" {
		SET launchAzimuth TO 180 - launchAzimuth.
	}.
	
	IF launchAzimuth < 0 {
		SET launchAzimuth TO 360 + launchAzimuth.		//Converts negative degrees from north into heading
	}.
	
	RETURN launchAzimuth.

	//#close Output

}. //FUNCTION LAZcalc