// example_lib_num_to_formatted_str.ks 
// Copyright © 2018,2019 KSLib team 
// Lic. MIT

RUN lib_num_to_formated_str.
CLEARSCREEN.
ABORT OFF.
LOCAL scriptStart IS TIME:SECONDS.
PRINT "si_formatting is formatting the altitude".
PRINT "padding is showing the pitch of the craft".
PRINT "time_formatting is formatting all time values".
PRINT " ".
PRINT " +------------------------+ ".
PRINT " | Altitude:              | ".
PRINT " +------------------------+ ".
PRINT " |    Pitch:              | ".
PRINT " +------------------------+ ".
PRINT " |  Started:           Ago| ".
PRINT " +------------------------+ ".
PRINT " | Time Since Game Start  | ".
PRINT " |                        | ".
PRINT " +------------------------+ ".
PRINT " ".
PRINT "Turn on ABORT to end script".


UNTIL ABORT {
  PRINT si_formatting(SHIP:ALTITUDE,"m") AT (12,5).
  PRINT padding(90 - VANG(SHIP:UP:VECTOR, SHIP:FACING:VECTOR),2,1) AT (12,7).
  PRINT time_formatting(TIME:SECONDS - scriptStart,5) AT (12,9).
  PRINT time_formatting(TIME:SECONDS,0) AT (3,12).
  WAIT 0.
}
