//example_draw_axes.ks

SWITCH TO 0.
RUN LIB_draw_axes.ks.
CLEARSCREEN.
PRINT "Creating SHIP:FACING vectors".
drawAxes(SHIP:FACING, green, 5, "SHIP:FACING").
WAIT 3.
PRINT "Creating RAW vectors".
drawAxes(R(0,0,0), blue, 5, "RAW").
WAIT 3.
PRINT "Creating UP vectors".
drawAxes(UP, red, 5, "UP").
WAIT 3.
PRINT "Removing previous two vectors".
drawAxesUndo().
WAIT 1.
drawAxesUndo().
WAIT 3.
PRINT "Creating NORTH vectors".
drawAxes(NORTH, yellow, 5, "NORTH").
WAIT 3.
PRINT "Removing all vectors".
drawAxesUndo().
drawAxesUndo().