//LIB_draw_axes.ks
//This file is distributed under the terms of the MIT license, (c) the KSLib team
//Authored by Dunbaratu, adapted by space_is_hard

@LAZYGLOBAL OFF.

GLOBAL axesDrawList TO LIST().

FUNCTION drawAxes {
	DECLARE PARAMETER
		dir,
		baseColor,
		scale,
		label.
	
	LOCAL colorOffset TO 0.3.

	LOCAL XVec TO VECDRAWARGS(
		V(0,0,0),
		dir*V(1,0,0),
		RGB(baseColor:RED+colorOffset, baseColor:GREEN-colorOffset, baseColor:BLUE-colorOffset),
		label + " X",
		scale,
		TRUE
	).
	
	LOCAL YVec TO VECDRAWARGS(
		V(0,0,0),
		dir*V(0,1,0),
		RGB(baseColor:RED-colorOffset, baseColor:GREEN+colorOffset, baseColor:BLUE-colorOffset),
		label + " Y",
		scale,
		TRUE
	).
	
	LOCAL ZVec TO VECDRAWARGS(
		V(0,0,0),
		dir*V(0,0,1),
		RGB(baseColor:RED-colorOffset, baseColor:GREEN-colorOffset, baseColor:BLUE+colorOffset),
		label + " Z",
		scale,
		TRUE
	).
	axesDrawList:ADD(
		LIST(
			XVec,
			YVec,
			Zvec
		)
	).
}.

FUNCTION drawAxesUndo {
	IF axesDrawList:LENGTH > 0 {
		LOCAL undoNum TO axesDrawList[axesDrawList:LENGTH-1]:LENGTH-1.
		
		UNTIL undoNum < 0 {
			LOCAL i TO axesDrawList[axesDrawList:LENGTH-1][undoNum].
			SET i:SHOW TO FALSE.
			axesDrawList[axesDrawList:LENGTH-1]:REMOVE(undoNum).
			SET undoNum TO undoNum - 1.
		}.
		
		axesDrawList:REMOVE(axesDrawList:LENGTH-1).
	}.
}.