// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL OFF.

LOCAL termIn IS TERMINAL:INPUT.
LOCAL backChar IS termIn:BACKSPACE.
LOCAL delChar IS termIn:DELETERIGHT.
LOCAL enterChar IS termIn:ENTER.

FUNCTION terminal_input {
  PARAMETER col,
  row,
  onlyNum,
  maxStrLength,
  returnString IS "",
  cursorBlink IS TRUE.
  LOCAL concatenator IS string_concatnation@.
  IF returnString:ISTYPE("scalar") {
    LOCAL signChar IS CHOOSE "-" IF returnString < 0 ELSE " ".
    SET returnString TO ABS(returnString):TOSTRING().
    IF returnString:CONTAINS("E") {
      LOCAL strSplit IS returnString:SPLIT("E").
      LOCAL mantissa IS strSplit[0].
      LOCAL exponent IS strSplit[1]:TOSCALAR().
      IF mantissa:MATCHESPATTERN(".") {
        LOCAL splitMant IS mantissa:SPLIT(".").
        SET mantissa TO splitMant[0] + splitMant[1].
        SET exponent TO exponent - splitMant[1]:LENGTH.
      }
      IF exponent < 0 {
        SET returnString TO "0." + (" ":PADRIGHT(ABS(exponent))):REPLACE(" ","0") + mantissa.
      } ELSE IF exponent > 0 {
        SET returnString TO mantissa + (" ":PADRIGHT(exponent)):REPLACE(" ","0").
        print returnString.
      } ELSE {
        SET returnString TO mantissa.
      }
    }
    SET returnString TO signChar + returnString.
  }
  print returnString.
  IF returnString:LENGTH > maxStrLength {
    SET returnString TO returnString:SUBSTRING(0,maxStrLength).
  }
  IF onlyNum {
    IF (returnString:LENGTH < 1) OR (NOT returnString[0]:MATCHESPATTERN("[ -]")) {
      SET returnString TO " ".
    }
    SET concatenator TO number_concatnation@.
  }
  
  LOCAL blinkInter IS 0.5.
  LOCAL blinkNextState IS TIME:SECONDS.
  LOCAL blinkChar IS " ".
  
  LOCAL doPrint IS TRUE.
  LOCAL done IS FALSE.
  UNTIL done {
    IF cursorBlink {
      IF blinkNextState < TIME:SECONDS {
        SET blinkNextState TO blinkNextState + blinkInter.
        SET blinkChar TO CHOOSE "█" IF blinkChar <> "█" ELSE "_".
        SET doPrint TO TRUE.
      }
    }
    IF termIn:HASCHAR {
      LOCAL cha IS termIn:GETCHAR().
      IF cha <> enterChar {
        SET returnString TO concatenator(returnString,cha,maxStrLength).
        SET doPrint TO TRUE.
      } ELSE {
        SET done TO TRUE.
        SET doPrint TO TRUE.
        SET blinkChar TO " ".
      }
    }
    IF doPrint {
      SET doPrint TO FALSE.
      LOCAL padChar IS (CHOOSE blinkChar IF returnString:LENGTH < maxStrLength ELSE "").
      PRINT (returnString + padChar):PADRIGHT(maxStrLength) AT(col,row).
    }
    WAIT 0.
  }
  RETURN CHOOSE number_protect(returnString) IF onlyNum ELSE returnString.
}

LOCAL FUNCTION number_concatnation {
  PARAMETER curentString,//expects " " as the base string to start with
  cha,
  maxLength.
   IF (cha = backChar) AND (curentString:LENGTH > 1)  {
    RETURN curentString:REMOVE(curentString:LENGTH - 1,1).
  }
  IF cha = delChar {
    SET curentString TO " ".
  }
  IF cha:MATCHESPATTERN("[0-9-.+]") {
    IF curentString:LENGTH < maxLength {
      IF cha:MATCHESPATTERN("[0-9]") {
        RETURN curentString + cha.
      } ELSE IF cha = "." {
        IF curentString:CONTAINS(".") {
          RETURN curentString.
        } ELSE {
          RETURN curentString + cha.
        }
      }
    }
    IF cha = "-" OR cha = "+" {
      IF curentString:CONTAINS("-") OR cha = "+" {
        RETURN " " + curentString:REMOVE(0,1).
      } ELSE {
        RETURN cha + curentString:REMOVE(0,1).
      }
    }
  }
  PRINT CHAR(7).
  RETURN curentString.
}

FUNCTION number_protect {
  PARAMETER curentString.
  IF curentString:LENGTH <= 1 {
    RETURN " 0".
  }
  IF curentString[curentString:LENGTH - 1] = "." {
    RETURN number_protect(curentString:REMOVE(curentString:LENGTH - 1,1)).
  }
  RETURN curentString.
}

LOCAL toIgnore IS LIST(
  CHAR(127),
  termIn:UPCURSORONE,
  termIn:DOWNCURSORONE,
  termIn:LEFTCURSORONE,
  termIn:RIGHTCURSORONE,
  termIn:HOMECURSOR,
  termIn:ENDCURSOR,
  termIn:PAGEDOWNCURSOR,
  termIn:PAGEUPCURSOR
).
LOCAL FUNCTION string_concatnation {
  PARAMETER curentString,
  cha,
  maxLength.
  IF (cha = backChar) AND (curentString:LENGTH > 0) {
    RETURN curentString:REMOVE(curentString:LENGTH - 1,1).
  }
  IF cha = delChar {
    SET curentString TO "".
  }
  IF (UNCHAR(cha) > 31) AND (NOT toIgnore:CONTAINS(cha)) {
    IF curentString:LENGTH < maxLength {
      RETURN curentString + cha.
    }
  }
  PRINT CHAR(7).
  RETURN curentString.
}