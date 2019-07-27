// This file is distributed under the terms of the MIT license, (c) the KSLib team

RUN lib_number_to_formated_str.
CLEARSCREEN.
ABORT OFF.
LOCAL scriptStart IS TIME:SECONDS.
PRINT "si_formating is formating the altitude".
PRINT "padding is showing the pitch of the craft".
PRINT "time_formating is formating all time values".
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
  PRINT si_formating(SHIP:ALTITUDE,"m") AT (12,5).
  PRINT padding(90 - VANG(SHIP:UP:VECTOR, SHIP:FACING:VECTOR),2,1) AT (12,7).
  PRINT time_formating(TIME:SECONDS - scriptStart,5) AT (12,9).
  PRINT time_formating(TIME:SECONDS,0) AT (3,12).
  WAIT 0.
}