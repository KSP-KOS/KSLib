// lib_input_terminal.ks provides functions for getting user entered strings or numbers though terminal inputs.
// Copyright © 2020 KSLib team 
// Lic. MIT
@LAZYGLOBAL OFF.

LOCAL termIn IS TERMINAL:INPUT.     
LOCAL backChar IS termIn:BACKSPACE. 
LOCAL delChar IS termIn:DELETERIGHT.
LOCAL enterChar IS termIn:ENTER.    
LOCAL bellChar IS CHAR(7).          

FUNCTION terminal_input_string {
  PARAMETER col,
    row,
    maxLength IS (TERMINAL:WIDTH - col),
    inValue IS "",
    cursorBlink IS TRUE.
  
  IF inValue:ISTYPE("scalar") {
    SET inValue TO scalar_to_string(inValue).
  }
  RETURN input_loop(col,row,maxLength,0,inValue,cursorBlink,string_concatnation@).
}

FUNCTION terminal_input_number {
  PARAMETER col,
    row,
    maxLength IS (TERMINAL:WIDTH - col),
    inValue IS " ",
    cursorBlink IS TRUE.
  
  IF inValue:ISTYPE("string") {
    IF inValue:TOSCALAR(0) = 0 {
      SET inValue TO " ".
    }
  }
  IF inValue:ISTYPE("scalar") {
    SET inValue TO scalar_to_string(inValue).
  }
  
  IF (inValue:LENGTH < 1) OR (NOT inValue[0]:MATCHESPATTERN("[ -]")) {
    SET inValue TO " ".
  }
  RETURN number_protect(input_loop(col,row,maxLength,1,inValue,cursorBlink,number_concatnation@)).
}

FUNCTION input_loop {
  PARAMETER col,
    row,
    maxLength,
    minLength,
    workingStr,
    cursorBlink,
    concatenator.

  IF workingStr:LENGTH > maxLength {
    SET workingStr TO workingStr:SUBSTRING(0,maxLength).
  }
  
  LOCAL blinkInter IS CHOOSE 0.5 IF cursorBlink ELSE 1000.
  LOCAL blinkNextState IS TIME:SECONDS.
  LOCAL blinkChar IS "_".
  
  LOCAL doPrint IS TRUE.
  LOCAL done IS FALSE.
  UNTIL done {
    IF blinkNextState < TIME:SECONDS {
      SET blinkNextState TO blinkNextState + blinkInter.
      IF cursorBlink {
        SET blinkChar TO CHOOSE "█" IF blinkChar <> "█" ELSE "_".
        SET doPrint TO TRUE.
      }
    }
    IF termIn:HASCHAR {
      LOCAL cha IS termIn:GETCHAR().
      SET doPrint TO TRUE.
      
      IF cha = backChar {
        IF workingStr:LENGTH > minLength {
          SET workingStr TO workingStr:REMOVE(workingStr:LENGTH - 1,1).
        } ELSE {
          PRINT bellChar.
        }
      } ELSE IF cha = delChar {
        SET workingStr TO "".
        PRINT bellChar.
      } ELSE IF cha = enterChar {
        SET done TO TRUE.
        SET blinkChar TO " ".
      } ELSE {
        SET workingStr TO concatenator(workingStr,cha,maxLength).
      }
    }
    IF doPrint {
      SET doPrint TO FALSE.
      LOCAL padChar IS (CHOOSE blinkChar IF workingStr:LENGTH < maxLength ELSE "").
      PRINT (workingStr + padChar):PADRIGHT(maxLength) AT(col,row).
    }
    WAIT UNTIL (termIn:HASCHAR) OR (blinkNextState < TIME:SECONDS) OR done.
  }
  RETURN workingStr.
}

LOCAL FUNCTION scalar_to_string {
  PARAMETER scalar.
  LOCAL signChar IS CHOOSE "-" IF scalar < 0 ELSE " ".
  LOCAL returnStr TO ABS(scalar):TOSTRING().
  IF returnStr:CONTAINS("E") {
    LOCAL strSplit IS returnStr:SPLIT("E").
    LOCAL mantissa IS strSplit[0].
    LOCAL exponent IS strSplit[1]:TOSCALAR().
    IF mantissa:CONTAINS(".") {
      LOCAL splitMant IS mantissa:SPLIT(".").
      SET mantissa TO splitMant[0] + splitMant[1].
      SET exponent TO exponent - splitMant[1]:LENGTH.
    }
    IF exponent < 0 {
      SET returnStr TO "0." + (" ":PADRIGHT(ABS(exponent + 1))):REPLACE(" ","0") + mantissa.
    } ELSE IF exponent > 0 {
      SET returnStr TO mantissa + (" ":PADRIGHT(exponent)):REPLACE(" ","0").
    } ELSE {
      SET returnStr TO mantissa.
    }
  }
  RETURN signChar + returnStr.
}

LOCAL FUNCTION number_protect {
  PARAMETER curentStr.
  IF curentStr:LENGTH <= 1 { 
    RETURN " 0".
  }
  IF curentStr[curentStr:LENGTH - 1] = "." {
    RETURN number_protect(curentStr:REMOVE(curentStr:LENGTH - 1,1)).
  }
  IF curentStr:TOSCALAR(0) = 0 { 
    RETURN " 0".
  }
  RETURN curentStr.
}

LOCAL FUNCTION number_concatnation {
  PARAMETER curentStr,//expects " " as the base string to start with
  cha,
  maxLength.
  IF curentStr:LENGTH < 1 {
    SET curentStr TO " ".
  }
  IF cha:MATCHESPATTERN("[0-9-.+]") {
    IF curentStr:LENGTH < maxLength {
      IF cha:MATCHESPATTERN("[0-9]") {
        RETURN curentStr + cha.
      } ELSE IF cha = "." {
        IF NOT curentStr:CONTAINS(".") {
          RETURN curentStr + cha.
        }
      }
    }
    IF cha = "-" OR cha = "+" {
      IF curentStr:CONTAINS("-") OR cha = "+" {
        RETURN " " + curentStr:REMOVE(0,1).
      } ELSE {
        RETURN cha + curentStr:REMOVE(0,1).
      }
    }
  }
  PRINT bellChar.
  RETURN curentStr.
}

LOCAL toIgnore IS LIST(
  CHAR(127),
  delChar,
  backChar,
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
  PARAMETER curentStr,
  cha,
  maxLength.
  IF (UNCHAR(cha) > 31) AND (NOT toIgnore:CONTAINS(cha)) {
    IF curentStr:LENGTH < maxLength {
      RETURN curentStr + cha.
    }
  }
  PRINT bellChar.
  RETURN curentStr.
}