//This file is distributed under the terms of the MIT license, (c) the KSLib team
//=====LAUNCH AZIMUTH CALCULATOR=====
//~~LIB_LAZcalc.ks~~
//~~Version 2.0~~
//~~Created by space-is-hard~~
//~~Updated by TDW89~~

//To use: RUN LAZcalc.ks. SET data TO LAZcalc_init([desired circular orbit altitude in kilometers],[desired orbital inclination; negative if launching from descending node, positive otherwise]). Then loop SET myAzimuth TO LAZcalc(data).

@LAZYGLOBAL OFF.

FUNCTION LAZcalc_init {
 PARAMETER
  desiredAlt, //Altitude of desired target orbit (in kilometers)
  desiredInc. //Inclination of desired target orbit
  
 LOCAL data IS LIST().   // A list is used to store information used by LAZcalc

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
  set inc to abs(ship:geoposition:lat).
  HUDTEXT("Inclination impossible from current latitude, setting for closest possible inclination.", 10, 2, 30, RED, FALSE).
 }.
 if 180-abs(ship:geoposition:lat) < abs(desiredInc) {
  set inc to 180-abs(ship:geoposition:lat).
  HUDTEXT("Inclination impossible from current latitude, setting for closest possible inclination.", 10, 2, 30, RED, FALSE).
 }.
 
 //#close Input Sterilization
 
 //Does all the one time calculations and stores them in a list to help reduce the overhead or continuously updating
 LOCAL launchLatitude IS SHIP:LATITUDE.
 LOCAL equatorialVel IS (2 * CONSTANT():Pi * BODY:RADIUS) / BODY:ROTATIONPERIOD.
 LOCAL targetOrbVel IS SQRT(BODY:MU/ (BODY:RADIUS + desiredAlt)).
 data:ADD(desiredInc).     //[0]
 data:ADD(launchLatitude). //[1]
 data:ADD(equatorialVel).  //[2]
 data:ADD(targetOrbVel).   //[3]
 RETURN data.
}.

function LAZcalc {
 PARAMETER
  data. //pointer to the list created by LAZcalc_init
 LOCAL inertialAzimuth IS ARCSIN(max(min(COS(data[0])/COS(SHIP:LATITUDE),1),-1)).
 LOCAL VXRot IS data[3]*SIN(inertialAzimuth)-data[2]*COS(data[1]).
 LOCAL VYRot IS data[3]*COS(inertialAzimuth).
 LOCAL Azimuth IS ARCTAN2(VXRot,VYRot).

 // This clamps the result to values between 0 and 360.
 RETURN MOD(Azimuth+360,360).
}.
