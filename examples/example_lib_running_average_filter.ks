// example_lib_running_average_filter.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT//Authored by space_is_hard

SWITCH TO 0.
RUN lib_running_average_filter.

SET TERMINAL:HEIGHT TO 30.
SET TERMINAL:WIDTH TO 60.
CLEARSCREEN.

LOCAL testList TO LIST().

//Build list that increments by one but with a decent amount of noise
FROM {SET i TO 0.} UNTIL i = 24 STEP {SET i TO i + 1.} DO {
    LOCAL randomNumber TO ROUND(3 * RANDOM()).
    testList:ADD(randomNumber + i).
}.
PRINT testList.

//Set up filter, length of three and an init value of 1
LOCAL numFilter TO running_average_filter_init(3,1).

//Feed test list to filter
FROM {SET i TO 0.} UNTIL i = 24 STEP {SET i TO i + 1.} DO {
    LOCAL testVal TO running_average_filter(numFilter, testList[i]).
    
    //Print filter results next to the test list that we printed earlier
    PRINT testVal AT(30, i + 1).
    WAIT 0.25.
}.