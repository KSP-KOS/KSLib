// lib_num_to_formatted_str_tests.ks 
// Copyright © 2021 KSLib team 
// Lic. MIT

@lazyglobal off.

// run lib_num_to_formatted_str.ks.
RUNPATH("0:/kslib things/lib_num_to_formatted_str.ks").
CLEARSCREEN.


//padding tests 
assert(padding(1,2,2)  = " 01.00").
assert(padding(-1,2,2) = "-01.00").

//parameter 2
assert(padding(1,1,2)   = " 1.00").
assert(padding(-1,1,2)  = "-1.00").
assert(padding(1,2,2)   = " 01.00").
assert(padding(-1,2,2)  = "-01.00").
assert(padding(10,1,2)  = " 10.00").
assert(padding(-10,1,2) = "-10.00").

//parameter 3
assert(padding(1.1,2,0)  = " 01").
assert(padding(1.9,2,0)  = " 02").
assert(padding(1,2,1)    = " 01.0").
assert(padding(1.01,2,1) = " 01.0").
assert(padding(1.09,2,1) = " 01.1").
assert(padding(1.1,2,2)  = " 01.10").

//parameter 4
assert(padding(1,2,2,TRUE)   = " 01.00").
assert(padding(1,2,2,FALSE)  = "01.00").
assert(padding(-1,2,2,TRUE)  = "-01.00").
assert(padding(-1,2,2,FALSE) = "-01.00").

//parameter 5
assert(padding(1.1,2,0,TRUE,0) = " 01").
assert(padding(1.9,2,0,TRUE,0) = " 02").
assert(padding(1.1,2,0,TRUE,1) = " 01").
assert(padding(1.9,2,0,TRUE,1) = " 01").
assert(padding(1.1,2,0,TRUE,2) = " 02").
assert(padding(1.9,2,0,TRUE,2) = " 02").


//si_formatting tests
assert(si_formatting(70000,"m")    = " 70.00 km").
assert(si_formatting(0.1,"m")      = " 100.0 mm").
assert(si_formatting(1000.1,"m")   = " 1.000 km").
assert(si_formatting(500,"m/s")    = " 500.0  m/s").
assert(si_formatting(999.99,"m/s") = " 1.000 km/s").


//time_formatting tests

LOCAL oneSec IS 1.
LOCAL oneMin IS 60*oneSec.
LOCAL oneMS IS oneMin + oneSec.
LOCAL oneHour IS 60*oneMin.
LOCAL oneHMS IS oneHour + oneMS.
LOCAL oneDay IS KUNIVERSE:HOURSPERDAY * oneHour.
LOCAL oneDHMS IS oneDay + oneHMS.
LOCAL oneYear IS (CHOOSE 365 IF KUNIVERSE:HOURSPERDAY = 24 ELSE 426) * oneDay.
LOCAL oneYDHMS IS oneYear + oneDHMS.

//parameter 3 though 5 tests

assert(time_formatting(oneMin)                 = " 01m 00s").
assert(time_formatting(oneMin + 0.1)           = " 01m 00s").
assert(time_formatting(oneMin + 0.9)           = " 01m 01s").
assert(time_formatting(oneMin - 0.1)           = " 01m 00s").
assert(time_formatting(oneYDHMS * 2 - 2.1)     = " 002y 002d 02h 02m 00s").
assert(time_formatting(oneMin,0,2)             = " 01m 00.00s").
assert(time_formatting(oneMin + 0.009,0,2)     = " 01m 00.01s").
assert(time_formatting(oneMin + 0.001,0,2)     = " 01m 00.00s").
assert(time_formatting(-oneMin,0,1)            = "-01m 00.0s").
assert(time_formatting(-oneMin,0,0,true)       = "T- 01m 00s").
assert(time_formatting(oneMin,0,2,true)        = "T+ 01m 00.00s").
assert(time_formatting(oneMin,0,1,false,true)  = "+01m 00.0s").
assert(time_formatting(oneMin,0,0,false,false) = " 01m 00s").


//format tests

assert(time_formatting(oneSec,0)   = " 01s").
assert(time_formatting(oneMS,0)    = " 01m 01s").
assert(time_formatting(oneYDHMS,0) = " 001y 001d 01h 01m 01s").

assert(time_formatting(oneYear,1)  = " 001 Years, 000 Days, 00:00:00").
assert(time_formatting(oneYear,2)  = " 001 Years, 000 Days, 00 Hours, 00 Minutes, 00 Seconds").
assert(time_formatting(oneYDHMS,2) = " 001 Years, 001 Days, 01 Hours, 01 Minutes, 01 Seconds").
						    
assert(time_formatting(oneDay,3)   = padding(KUNIVERSE:HOURSPERDAY,2,0) + ":00:00").
assert(time_formatting(oneHour,3)  = " 01:00:00").
assert(time_formatting(oneMin,3)   = " 01:00").
assert(time_formatting(oneSec,3)   = " 01").
						    
assert(time_formatting(oneDay,4)   = padding(KUNIVERSE:HOURSPERDAY,2,0) + ":00:00").
assert(time_formatting(oneHour,4)  = " 01:00:00").
assert(time_formatting(oneMin,4)   = " 00:01:00").
assert(time_formatting(oneSec,4)   = " 00:00:01").
						    
assert(time_formatting(oneYear,5)  = " 001y 000d ").
assert(time_formatting(oneDay,5)   = " 001d 00h  ").
assert(time_formatting(oneHour,5)  = " 01h  00m  ").
assert(time_formatting(oneMin,5)   = " 01m  00s  ").
assert(time_formatting(oneSec,5)   = " 00m  01s  ").
						    
assert(time_formatting(oneYear,6)  = " 001 Years   000 Days    ").
assert(time_formatting(oneDay,6)   = " 001 Days    00 Hours    ").
assert(time_formatting(oneHour,6)  = " 01 Hours    00 Minutes  ").
assert(time_formatting(oneMin,6)   = " 01 Minutes  00 Seconds  ").
assert(time_formatting(oneSec,6)   = " 00 Minutes  01 Seconds  ").

PRINT "all tests passed".

FUNCTION assert {
  PARAMETER boolean.
  IF NOT boolean
  {
    PRINT "test failed".
	PRINT 1/0.
  }
}