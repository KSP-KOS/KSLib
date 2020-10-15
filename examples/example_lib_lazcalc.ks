// example_lib_lazcalc.ks is a LIB_LAZcalc.ks testing example
// Copyright © 2015 KSLib team 
// Lic. MIT
SWITCH TO 0.
RUN lib_lazcalc.ks.
CLEARSCREEN.
SET TERMINAL:WIDTH TO 50.

LOCAL launchAzimuth TO 0.

PRINT "Target Alt | Target Inc | Node    | Launch Azimuth".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(130000,0).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  130km    |  0deg      | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(450000,51.6).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  450km    |  51.6deg   | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(120000,40).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  120km    |  40deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(500000,-60).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  500km    |  60deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(130000,-180).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  130km    |  180deg    | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(250000,120).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  250km    |  120deg    | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(150000,-90).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  150km    |  90deg     | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(250000,90).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  250km    |  90deg     | Asc     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
SET struct to LAZcalc_init(1000000,-105).
SET launchAzimuth TO LAZcalc(struct).
PRINT "  1000km   |  105deg    | Dec     | " +  ROUND(launchAzimuth,2) + "deg".
PRINT "--------------------------------------------------".
