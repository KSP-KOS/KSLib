//LIB_LAZcalc.ks testing example
//This file is distributed under the terms of the MIT license, (c) the KSLib team

SWITCH TO 0.
RUN lib_lazcalc.ks.
CLEARSCREEN.
SET TERMINAL:WIDTH TO 50.

LOCAL launchAzimuth TO 0.

PRINT "If your target altitude is:    km" AT(0,0).
PRINT "And your target inclination is:    deg" AT(0,1).
PRINT "Launching at the descending node" AT(0,2).
PRINT "Then your launch azimuth should be:      deg" AT(0,3).

PRINT 500 AT(28,0).
PRINT 35 AT(33,1).
PRINT "Ascending " AT(17,2).
SET launchAzimuth TO LAZcalc(500,35).
PRINT ROUND(launchAzimuth,1) AT(36,3).

WAIT 5.

PRINT 120 AT(28,0).
PRINT 86 AT(33,1).
PRINT "Ascending " AT(17,2).
SET launchAzimuth TO LAZcalc(120,3586).
PRINT ROUND(launchAzimuth,1) AT(36,3).

WAIT 5.

PRINT 250 AT(28,0).
PRINT 56 AT(33,1).
PRINT "Descending" AT(17,2).
SET launchAzimuth TO LAZcalc(250,-56).
PRINT ROUND(launchAzimuth,1) AT(36,3).

WAIT 5.

PRINT 800 AT(28,0).
PRINT 150 AT(33,1).
PRINT "Ascending " AT(17,2).
SET launchAzimuth TO LAZcalc(800,150).
PRINT ROUND(launchAzimuth,1) AT(36,3).

WAIT 5.

PRINT 100 AT(28,0).
PRINT 5 AT(33,1).
PRINT "Descending" AT(17,2).
SET launchAzimuth TO LAZcalc(100,-5).
PRINT ROUND(launchAzimuth,1) AT(36,3).

WAIT 5.
CLEARSCREEN.