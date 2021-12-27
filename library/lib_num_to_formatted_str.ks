// lib_num_to_formatted_str.ks provides several functions for changing numbers (scalers) into strings with specified formats
// Copyright © 2018,2019,2020 KSLib team 
// Lic. MIT

@LAZYGLOBAL OFF.

LOCAL lib_formatting_lex IS LEX().

LOCAL FUNCTION time_converter {
  PARAMETER timeValue,  // the time in seconds to convert
  places.               // how many time places (e.g HH:MM:SS has 3 places)
  SET timeValue TO TIMESPAN(timeValue).
  
  IF timeValue:MINUTES < 1 OR places = 1 {
	RETURN LIST(ROUND(timeValue:SECONDS,2)).
	
  } ELSE IF timeValue:HOURS < 1 OR places = 2 {
	RETURN LIST(ROUND(MOD(timeValue:SECONDS,60),2), timeValue:MINUTES).
	
  } ELSE IF timeValue:DAYS < 1 OR places = 3 {
    RETURN LIST(ROUND(MOD(timeValue:SECONDS,60),2), timeValue:MINUTE, timeValue:HOURS).
	
  } ELSE IF timeValue:YEARS < 1 OR places = 4 {
	RETURN LIST(ROUND(MOD(timeValue:SECONDS,60),2), timeValue:MINUTE, timeValue:HOUR, timeValue:DAYS).
	
  } ELSE {
	RETURN LIST(ROUND(MOD(timeValue:SECONDS,60),2), timeValue:MINUTE, timeValue:HOUR, timeValue:DAY, timeValue:YEARS).
  }
}

lib_formatting_lex:ADD("leading0List",LIST(2,2,2,3,3)).
LOCAL FUNCTION time_string {
  PARAMETER timeSec,    // the time in seconds to format
  fixedPlaces,          // number of required time places (e.g. HH:MM:SS has 3 fixedPlaces)
  stringList,           // separators for each time place (must have at least fixedPlaces elements!)
  rounding,             // rounding for the seconds place, range 0 to 2
  prependT,             // prepend a T- or T+ to format (T- or T if showPlus is FALSE)
  showPlus IS prependT. // by default only display "+" when prependT is TRUE

  // start by rounding the input so we don't have to "carry the one" in time_converter
  LOCAL roundingList IS LIST(MIN(rounding,2), 0, 0, 0, 0).
  SET timeSec TO ROUND(timeSec, roundingList[0]).

  LOCAL places IS stringList:LENGTH.
  LOCAL timeList IS time_converter(ABS(timeSec), places).
  LOCAL maxLength IS MIN(timeList:LENGTH, places).
  LOCAL returnString IS "".

  // fill in missing time places until format is reached
  // e.g. for HH:MM:SS, given 4s, put 0 in HH and MM place
  IF fixedPlaces > 0 {
    UNTIL timeList:LENGTH >= fixedPlaces {
      timeList:ADD(0).
    }
    SET maxLength TO MIN(timeList:LENGTH, places).
  } ELSE {
    SET fixedPlaces TO maxLength.
  }

  // add padding to each element in timeList and prepend to returnString
  FROM {LOCAL i IS maxLength - fixedPlaces.}
  UNTIL i >= maxLength STEP {SET i TO i + 1.} DO {
    LOCAL leading0List IS lib_formatting_lex["leading0List"][i].
    LOCAL pad_str IS padding(timeList[i], leading0List, roundingList[i], FALSE, 1).
    SET returnString TO pad_str + stringList[i] + returnString.
  }

  // the prependT strings have one space padding
  IF prependT SET returnString TO returnString:INSERT(0, " ").

  // all time_string formats have either '+','-', or ' ' for padding
  IF timeSec < 0 {
    SET returnString TO returnString:INSERT(0, "-").
  } ELSE IF showPlus {
    SET returnString TO returnString:INSERT(0, "+").
  } ELSE {
    SET returnString TO returnString:INSERT(0, " ").
  }

  IF prependT SET returnString TO returnString:INSERT(0, "T").

  RETURN returnString.
}

//adding list of format types
lib_formatting_lex:ADD("timeFormats",LIST()).
lib_formatting_lex["timeFormats"]:ADD(LIST(0,LIST("s","m ","h ","d ","y "))).
lib_formatting_lex["timeFormats"]:ADD(LIST(0,LIST("",":",":"," Days, "," Years, "))).
lib_formatting_lex["timeFormats"]:ADD(LIST(0,LIST(" Seconds"," Minutes, "," Hours, "," Days, "," Years, "))).
lib_formatting_lex["timeFormats"]:ADD(LIST(0,LIST("",":",":"))).
lib_formatting_lex["timeFormats"]:ADD(LIST(3,lib_formatting_lex["timeFormats"][3][1])).
lib_formatting_lex["timeFormats"]:ADD(LIST(2,LIST("s  ","m  ","h  ","d ","y "))).
lib_formatting_lex["timeFormats"]:ADD(LIST(2,LIST(" Seconds  "," Minutes  "," Hours    "," Days    "," Years   "))).

FUNCTION time_formatting {
  PARAMETER timeSec,    // the time in seconds to be formatted
  formatType IS 0,      // type of format to use, range 0 to 6
  rounding IS 0,        // rounding for the seconds place, range 0 to 2
  prependT IS FALSE,    // prepend a T- or T+ to format (T- or T if showPlus is FALSE)
  showPlus IS prependT. // by default only display "+" when prependT is TRUE


  LOCAL formatData IS lib_formatting_lex["timeFormats"][formatType].
  RETURN time_string(timeSec, formatData[0], formatData[1], rounding, prependT, showPlus).
}

lib_formatting_lex:ADD("siPrefixList",LIST(" y"," z"," a"," f"," p"," n"," μ"," m","  "," k"," M"," G"," T"," P"," E"," Z"," Y")).

FUNCTION si_formatting {
  PARAMETER num,  // number to format, should be in range 10^-24 to 10^24
  unit IS "".     // user supplied unit, output will prepend SI prefix

  IF num = 0 {
    RETURN padding(num,1,3) + "  " + unit.
  } ELSE {
    LOCAL powerOfTen IS MAX(MIN(FLOOR(LOG10(ABS(num))),26),-24).
    LOCAL SIfactor IS FLOOR(powerOfTen / 3).
    LOCAL trailingLength IS 3 - (powerOfTen - SIfactor * 3).

    SET num TO ROUND(num/1000^SIfactor,trailingLength) * 1000^SIfactor.

    SET powerOfTen TO MAX(MIN(FLOOR(LOG10(ABS(num))),26),-24).
    SET SIfactor TO FLOOR(powerOfTen / 3).
    SET trailingLength TO 3 - (powerOfTen - SIfactor * 3).

    LOCAL prefix IS lib_formatting_lex["siPrefixList"][SIfactor + 8].
    RETURN padding(num/1000^SIfactor,1,trailingLength,TRUE,0) + prefix + unit.
  }
}

LOCAL roundingFunctions IS LIST(ROUND @,FLOOR @,CEILING @).
FUNCTION padding {
  PARAMETER num,                // number to be formatted
  leadingLength,                // minimum digits to the left of the decimal
  trailingLength,               // digits to the right of the decimal
  positiveLeadingSpace IS TRUE, // whether to prepend a single space to the output
  roundType IS 0.               // 0 for normal rounding, 1 for floor, 2 for ceiling
  
  LOCAL returnString IS ABS(roundingFunctions[roundType](num,trailingLength)):TOSTRING.
  
  IF trailingLength > 0 {
    IF returnString:CONTAINS(".") {
      LOCAL splitString IS returnString:SPLIT(".").
      SET returnString TO (splitString[0]:PADLEFT(leadingLength) + "." + splitString[1]:PADRIGHT(trailingLength)):REPLACE(" ","0").
    } ELSE {
      SET returnString TO (returnString:PADLEFT(leadingLength) + "." + "0":PADRIGHT(trailingLength)):REPLACE(" ","0").
    }
  } ELSE IF returnString:LENGTH < leadingLength {
    SET returnString TO returnString:PADLEFT(leadingLength):REPLACE(" ","0").
  }

  IF num < 0 {
    RETURN "-" + returnString.
  } ELSE {
    IF positiveLeadingSpace {
      RETURN " " + returnString.
    } ELSE {
      RETURN returnString.
    }
  }
}