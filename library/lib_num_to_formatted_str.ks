// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL OFF.

LOCAL lib_formatting_lex IS LEX().
{
  LOCAL hoursInDay IS KUNIVERSE:HOURSPERDAY.
  LOCAL daysInYear IS 365.
  IF hoursInDay = 6 { SET daysInYear TO 426. }
  lib_formatting_lex:ADD("timeModList",LIST(60,60,hoursInDay,daysInYear)).
}

LOCAL FUNCTION time_converter {
  PARAMETER timeValue,  // the time in seconds to convert
  places.               // how many time places (e.g HH:MM:SS has 3 places)

  LOCAL returnList IS LIST().
  LOCAL localTime IS timeValue.
  LOCAL place IS 1.

  FOR modValue IN lib_formatting_lex["timeModList"] {
    LOCAL remainder IS MOD(localTime, modValue).

    // add the remainder to the output
    returnList:ADD(remainder).

    // move along to the next place
    SET localTime TO FLOOR(localTime / modValue).
    IF localTime = 0 { BREAK. }
    SET place TO place + 1.
    IF place = places { BREAK. }
  }

  IF localTime > 0 { returnList:ADD(localTime). }
  RETURN returnList.
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
  SET timeSec TO ROUND(timeSec, rounding).

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

FUNCTION padding {
  PARAMETER num,                // number to be formatted
  leadingLength,                // minimum digits to the left of the decimal
  trailingLength,               // digits to the right of the decimal
  positiveLeadingSpace IS TRUE, // whether to prepend a single space to the output
  roundType IS 0.               // 0 for normal rounding, 1 for floor, 2 for ceiling

  LOCAL returnString IS "".
  //LOCAL returnString IS ABS(ROUND(num,trailingLength)):TOSTRING.
  IF roundType = 0 {
    SET returnString TO ABS(ROUND(num,trailingLength)):TOSTRING.
  } ELSE IF roundType = 1 {
    SET returnString TO ABS(adv_floor(num,trailingLength)):TOSTRING.
  } ELSE {
    SET returnString TO ABS(adv_ceiling(num,trailingLength)):TOSTRING.
  }

  IF trailingLength > 0 {
    IF NOT returnString:CONTAINS(".") {
      SET returnString TO returnString + ".0".
    }
    UNTIL returnString:SPLIT(".")[1]:LENGTH >= trailingLength { SET returnString TO returnString + "0". }
    UNTIL returnString:SPLIT(".")[0]:LENGTH >= leadingLength { SET returnString TO "0" + returnString. }
  } ELSE {
    UNTIL returnString:LENGTH >= leadingLength { SET returnString TO "0" + returnString. }
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

LOCAL FUNCTION adv_floor {
  PARAMETER num,dp.
  LOCAL multiplier IS 10^dp.
  RETURN FLOOR(num * multiplier)/multiplier.
}

LOCAL FUNCTION adv_ceiling {
  PARAMETER num,dp.
  LOCAL multiplier IS 10^dp.
  RETURN CEILING(num * multiplier)/multiplier.
}
