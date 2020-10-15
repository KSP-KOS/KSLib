// example_lib_input_terminal_complex.ks 
// Copyright © 2020 KSLib team 
// Lic. MIT

@LAZYGLOBAL OFF.

RUN lib_input_terminal.ks.

CLEARSCREEN.
SET TERMINAL:WIDTH TO 45.
SET TERMINAL:HEIGHT TO 25.
PRINT "+---------------+---+-----------------------+".
PRINT "|number0>       +---+                       |".
PRINT "|string0>           |                       |".
PRINT "|number1>           +---------------------+-|".
PRINT "|string1>                                 | |".
PRINT "+-----------------------------------------+-+".
PRINT "|                                           |".
PRINT "|                                           |".
PRINT "|                                           |".
PRINT "|                                           |".
PRINT "|                                           |".
PRINT "|                                           |".
PRINT "+-------------------------------------------+".
PRINT "|Type the name of the field you want to     |".
PRINT "|change, then type the value you want       |".
PRINT "|the field to hold and press enter.         |".
PRINT "|Type 'Quit' with prompt ':>' to end script.|".
PRINT "|                                           |".
PRINT "|EXAMPLE: typing 'number0' will change      |".
PRINT "|the prompt from ':>' to ':number0:>'       |".
PRINT "|and the thing that you type will go to     |".
PRINT "|the 'number0' field after enter is pressed.|".
PRINT "+-------------------------------------------+".

LOCAL fields IS LEXICON(
	"number0",LEXICON("maxLength",5,"col",10,"row",1,"str"," 1","isNum",TRUE,"inFunction",terminal_input_number@),
	"number1",LEXICON("maxLength",9,"col",10,"row",3,"str"," 2","isNum",TRUE,"inFunction",terminal_input_number@),
	"string0",LEXICON("maxLength",9,"col",10,"row",2,"str","Hello","isNum",FALSE,"inFunction",terminal_input_string@),
	"string1",LEXICON("maxLength",32,"col",10,"row",4,"str","World","isNum",FALSE,"inFunction",terminal_input_string@)
).
LOCAL exitWords IS LIST(
	"quit",
	"exit",
	"q",
	"e"
).
LOCAL prompt IS ":> ".
LOCAL terminalData IS LIST(prompt).
LOCAL terminalRowStart IS 5.
LOCAL termPos IS 0.
LOCAL inField IS "".
LOCAL inFunction IS terminal_input_string@.
LOCAL fieldStr IS "".
LOCAL maxIn IS 45.
FOR key IN fields:KEYS {
	LOCAL field IS fields[key].
	PRINT (field["str"]) AT(field["col"],field["row"]).
}
LOCAL quit IS FALSE.
RCS OFF.
UNTIL quit OR RCS {
	SET termPos TO 0.
	FOR line in terminalData {
		SET termPos TO termPos + 1.
		PRINT "|" + line:PADRIGHT(43) + "|" AT(0,terminalRowStart + termPos).
	}
	LOCAL indentation IS terminalData[terminalData:LENGTH - 1]:LENGTH + 1.
	LOCAL inString IS inFunction(indentation,terminalRowStart + termPos,MIN(44 - indentation,maxIn),fieldStr).
	SET terminalData[terminalData:LENGTH - 1] TO terminalData[terminalData:LENGTH - 1] + inString.
	
	IF inField <> "" {
		LOCAL field IS fields[inField].
		SET field["str"] TO inString.
		PRINT (field["str"]):PADRIGHT(maxIn - 1) AT(field["col"],field["row"]).
		terminalData:ADD(prompt).
		SET inField TO "".
		SET maxIn TO 45.
		SET inFunction TO terminal_input_string@.
		SET fieldStr TO "".
	} ELSE IF fields:HASKEY(inString) {
		SET inField TO inString.
		LOCAL field IS fields[inField].
		SET maxIn TO field["maxLength"].
		SET inFunction TO field["inFunction"].
		SET fieldStr TO field["str"].
		terminalData:ADD(":" + inString + prompt).
	} ELSE IF exitWords:CONTAINS(inString) {
		SET quit TO TRUE.
	} ELSE {
		terminalData:ADD(" Not a valid field or command!").
		terminalData:ADD(prompt).
	}
	UNTIL terminalData:LENGTH <= 6 {
		terminalData:REMOVE(0).
	} 
}