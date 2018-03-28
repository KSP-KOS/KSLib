@LAZYGLOBAL OFF.

LOCAL lib_formating_lex IS LEX().
{
  LOCAL hoursInDay IS KUNIVERSE:HOURSPERDAY.
  LOCAL daysInYear IS 365.
  IF hoursInDay = 6 { SET daysInYear TO 426. }
  lib_formating_lex:ADD("timeModList",LIST(60,60,hoursInDay,daysInYear)).
}

LOCAL FUNCTION time_converter {
  PARAMETER timeValue.
  LOCAL returnList IS LIST().
  LOCAL localTime IS timeValue.

  FOR modValue IN lib_formating_lex["timeModList"] {
    LOCAL returnValue IS MOD(localTime,modValue).
    returnList:ADD(returnValue).

    SET localTime TO FLOOR(localTime / modValue).
    IF localTime = 0 { BREAK. }
  }
  IF localTime > 0 { returnList:ADD(localTime). }
  RETURN returnList.
}

lib_formating_lex:ADD("leading0List",LIST(2,2,2,3,3)).
LOCAL FUNCTION time_string {
  PARAMETER timeSec, places, stringList, roundingList, tMinus.
  LOCAL timeList IS time_converter(ABS(timeSec)).
  LOCAL returnString IS "".

  LOCAL maxLength IS MIN(timeList:LENGTH, stringList:LENGTH).
  IF places > 0 {
    UNTIL timeList:LENGTH >= places {
      timeList:ADD(0).
      SET maxLength TO MIN(timeList:LENGTH, stringList:LENGTH).
    }
  } ELSE {
    SET places TO maxLength.
  }

  FROM {LOCAL i IS maxLength - (places).} UNTIL i >= maxLength STEP {SET i TO i + 1.} DO {
    SET returnString TO padding(timeList[i],lib_formating_lex["leading0List"][i],roundingList[i],FALSE) + stringList[i] + returnString.
  }

  IF timeSec < 0 {
    IF tMinus {
      RETURN returnString:INSERT(0,"T- ").
    } ELSE {
      RETURN returnString:INSERT(0,"-").
    }
  } ELSE {
    IF tMinus {
      RETURN returnString:INSERT(0,"T+ ").
    } ELSE {
      RETURN returnString:INSERT(0," ").
    }
  }
}

lib_formating_lex:ADD("timeFormat0",LIST("s  ","m  ","h  ","d ","y ")).
lib_formating_lex:ADD("timeFormat1",LIST("",":",":"," Days, "," Years, ")).
lib_formating_lex:ADD("timeFormat2",LIST(" Seconds"," Minutes, "," Hours, "," Days, "," Years, ")).
lib_formating_lex:ADD("timeFormat3",LIST("",":",":")).
//format 4 uses the same list as format 3
//format 5 uses the same list as format 0
lib_formating_lex:ADD("timeFormat6",LIST(" Seconds  "," Minutes  "," Hours    "," Days    "," Years   ")).

FUNCTION time_formating {
  PARAMETER timeSec,  //the time in seconds to format
  formatType IS 0,    //what type of format
  rounding IS 0,    //what rounding on the seconds
  tMinus IS FALSE.    //had a T- or T+ at the start of the formated time
  LOCAL roundingList IS LIST(MIN(rounding,2),0,0,0,0).
  IF formatType = 0 {
    RETURN time_string(timeSec,0,lib_formating_lex["timeFormat0"],roundingList,tMinus).
  } ELSE IF formatType = 1 {
    RETURN time_string(timeSec,0,lib_formating_lex["timeFormat1"],roundingList,tMinus).
  } ELSE IF formatType = 2 {
    RETURN time_string(timeSec,0,lib_formating_lex["timeFormat2"],roundingList,tMinus).
  } ELSE IF formatType = 3 {
    RETURN time_string(timeSec,0,lib_formating_lex["timeFormat3"],roundingList,tMinus).
  } ELSE IF formatType = 4 {
    RETURN time_string(timeSec,3,lib_formating_lex["timeFormat3"],roundingList,tMinus).
  } ELSE IF formatType = 5 {
    RETURN time_string(timeSec,2,lib_formating_lex["timeFormat0"],roundingList,tMinus).
  } ELSE IF formatType = 6 {
    RETURN time_string(timeSec,2,lib_formating_lex["timeFormat6"],roundingList,tMinus).
  }
}

lib_formating_lex:ADD("siPrefixList",LIST(" y"," z"," a"," f"," p"," n"," μ"," m","  "," k"," M"," G"," T"," P"," E"," Z"," Y")).

FUNCTION si_formating {
  PARAMETER num,//number to format,
  unit IS "".//unit of number
  IF num = 0 {
    RETURN padding(num,1,3) + "  " + unit.
  } ELSE {
    LOCAL powerOfTen IS MAX(MIN(FLOOR(LOG10(ABS(num))),26),-24).
    LOCAL SIfactor IS FLOOR(powerOfTen / 3).
    LOCAL trailingLength IS 3 - MOD(powerOfTen,3).
    LOCAL prefix IS lib_formating_lex["siPrefixList"][SIfactor + 8].
    RETURN padding(num/1000^SIfactor,1,trailingLength) + prefix + unit.
  }
}

FUNCTION padding {
  PARAMETER num,  //number to pad
  leadingLenght,  //min length to the left of the decimal point
  trailingLength,  // length to the right of the decimal point
  positiveLeadingSpace IS TRUE.//if when positive should there be a space before the returned string
  LOCAL returnString IS ABS(ROUND(num,trailingLength)):TOSTRING.

  IF trailingLength > 0 {
    IF NOT returnString:CONTAINS(".") {
      SET returnString TO returnString + ".0".
    }
    UNTIL returnString:SPLIT(".")[1]:LENGTH >= trailingLength { SET returnString TO returnString + "0". }
    UNTIL returnString:SPLIT(".")[0]:LENGTH >= leadingLenght { SET returnString TO "0" + returnString. }
  } ELSE {
    UNTIL returnString:LENGTH >= leadingLenght { SET returnString TO "0" + returnString. }
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