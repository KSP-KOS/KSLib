//LIB_LAZcalc.ks testing example
//This file is distributed under the terms of the MIT license, (c) the KSLib team

SWITCH TO 0.
RUN lib_lazcalc.ks.
CLEARSCREEN.
SET TERMINAL:WIDTH TO 50.

LOCAL launchAzimuth TO 0.

PRINT "Target Alt | Target Inc | Node    | Launch Azimuth".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(130,0)
SET launchAzimuth TO LAZcalc(struct).
PRINT "  130km    |  0deg      | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(450,51.6).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  450km    |  51.6deg   | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(120,40).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  120km    |  40deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(500,-60).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  500km    |  60deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(130,-180).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  130km    |  180deg    | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(250,120).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  250km    |  120deg    | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(150,-90).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  150km    |  90deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(250,90).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  250km    |  90deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(1000,-105).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  1000km   |  105deg    | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
