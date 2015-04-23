//LIB_LAZcalc.ks testing example
//This file is distributed under the terms of the MIT license, (c) the KSLib team

SWITCH TO 0.
RUN lib_lazcalc.ks.

DECLARE PARAMETER desalt.		//Pull desired altitude from user input
DECLARE PARAMETER desinc.		//Pull desired inclination from user input

LOCAL mylaz to 0.

SET mylaz to lazcalc(desalt, desinc).
PRINT "LAUNCH AZIMUTH: " + ROUND(mylaz, 2).