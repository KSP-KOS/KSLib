// example_lib_input_terminal_simple.ks 
// Copyright © 2020 KSLib team 
// Lic. MIT

@LAZYGLOBAL OFF.

RUN lib_input_terminal.ks.

CLEARSCREEN.
PRINT " ".
PRINT " ".
LOCAL inStr IS "".
UNTIL inStr = "exit" {
  PRINT "Type 'exit' to end the script" AT(0,0).
  PRINT "Input String: " AT(0,1).
  SET inStr TO terminal_input_string(14,1).
  PRINT "Your string: " + inStr.
}