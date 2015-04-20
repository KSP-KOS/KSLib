SET nNode TO NEXTNODE.
SET g_0 TO 9.80665.
// Time before burn start to start lining up:
SET node_Ready TO 30.
SET ease_Off_Period to 1.
SET max_Error TO 0.01.

//// Then I need to calculate the actual burn time.

// Assuming all engines have thrustLimits set to 100%.

SET sum TO 0.
LIST ENGINES IN engList.
FOR eng IN engList {
    IF eng:IGNITION() AND eng:ISP > 0 { // If this engine is currently active and valid.
        SET sum TO sum + (eng:MAXTHRUST / eng:ISP).
    }.
}.
SET isp TO ( SHIP:MAXTHRUST / sum ).

LOCK burnTime TO ((MASS * isp * g_0) / MAXTHRUST) * (1 - CONSTANT():E ^ (-1 * nNode:DELTAV:MAG / (isp * g_0))).
CLEARSCREEN.
PRINT "Burn time calculated to be = " + ROUND(burnTime, 2) AT (0,0).


//// Then a little before burn time I need to align with the node.

UNTIL nNode:ETA <= (burnTime / 2) + node_Ready {
	PRINT ROUND(nNode:ETA - ((burnTime / 2) + node_Ready), 2) + " Seconds until alignment begins " AT (0, 2).
	WAIT 0.1.
}.

//Time to align.
SAS OFF.
RCS ON.
PRINT "Aligning..." AT (0, 3).
LOCK STEERING TO LOOKDIRUP(nNode:DELTAV, SUN:POSITION).
WAIT UNTIL nNode:ETA <= (burnTime / 2) + node_Ready / 2.
SAS ON.
RCS OFF.


//// Then at half that time before the node I need to start thrusting.

UNTIL nNode:ETA <= burnTime / 2 {
	PRINT ROUND(nNode:ETA - (burnTime / 2), 2) + " Seconds until burn begins " AT (0, 4).
	WAIT 0.0001.
}.

//OK! Time to burn!
LOCK THROTTLE TO (nNode:DELTAV:MAG * MASS / MAXTHRUST) * 2. // Throttles back when there's 0.5 seconds to go.
PRINT "YEEHAW!" AT (0, 6).

UNTIL ease_Off_Period * 2 >= burnTime {
	//Recaclulate remaining Burn Time.
	Print "Remaining Burn Time = " + ROUND(burnTime, 2) + " " AT (0, 8).
	Wait ease_Off_Period.
}.

//// Then when remaining burn time is 1 second, I need to start reducing thrust.
PRINT "Easing off" AT (0, 9).
UNTIL nNode:DELTAV:MAG < max_Error{
	PRINT "Throttle set to = " + ROUND(THROTTLE, 2) + " " AT (0, 10).
	WAIT 0.0001.
}.
CLEARSCREEN.
PRINT "Burn Complete. Total error = " + ROUND(nNode:DELTAV:MAG, 2) + " m/s.".
//REMOVE nNODE.
SAS ON.
