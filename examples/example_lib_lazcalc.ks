//LIB_LAZcalc.ks testing example
//This file is distributed under the terms of the MIT license, (c) the KSLib team

SWITCH TO 0.
RUN lib_lazcalc.ks.
CLEARSCREEN.
SET TERMINAL:WIDTH TO 50.

LOCAL launchAzimuth TO 0.

PRINT "Target Alt | Target Inc | Node    | Launch Azimuth".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(130,0).
PRINT "  130km    |  0deg      | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(450,51.6).
PRINT "  450km    |  51.6deg   | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(120,40).
PRINT "  120km    |  40deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(500,-60).
PRINT "  500km    |  60deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(250,120).
PRINT "  250km    |  120deg    | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(150,-90).
PRINT "  150km    |  90deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(250,90).
PRINT "  250km    |  90deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET launchAzimuth TO LAZcalc(1000,-105).
PRINT "  1000km   |  105deg    | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".