//PARAMETER inStr.

//constants needed for hashing
LOCAL k0 IS num_to_bin(1518500249,32).
LOCAL k1 IS num_to_bin(1859775393,32).
LOCAL k2 IS num_to_bin(2400959708,32).
LOCAL k3 IS num_to_bin(3395469782,32).

LOCAL h0Start IS num_to_bin(1732584193,32).
LOCAL h1Start IS num_to_bin(4023233417,32).
LOCAL h2Start IS num_to_bin(2562383102,32).
LOCAL h3Start IS num_to_bin(0271733878,32).
LOCAL h4Start IS num_to_bin(3285377520,32).

//PRINT bin_rotate_left("1001",2).
//LOCAL binA IS num_to_bin(FLOOR(RANDOM() * 16),4).
//LOCAL binB IS num_to_bin(FLOOR(RANDOM() * 16),4).
//PRINT    "     NOT " + binB + " = " + bin_NOT(binB).
//PRINT binA + "  OR " + binB + " = " + bin_OR(binA,binB).
//PRINT binA + " AND " + binB + " = " + bin_AND(binA,binB).
//PRINT binA + " XOR " + binB + " = " + bin_XOR(binA,binB).
//PRINT binA + "  +  " + binB + " = " + bin_ADD(binA,binB).
//WAIT 0.
//LOCAL startTime IS TIME:SECONDS.
//PRINT generate_hash(inStr,true).
//PRINT "deltaT: " + ROUND(TIME:SECONDS - startTime,2).

FUNCTION generate_hash {//an implementation of SHA-1 
	PARAMETER inStr, reduced IS FALSE.
	LOCAL inSrtLength IS inStr:LENGTH * 16.
	SET inStr TO inStr + CHAR(128).
	UNTIL MOD(inStr:LENGTH,32) = 28 { SET inStr TO inStr + CHAR(0). }
	
	LOCAL s1 IS MOD(inSrtLength,2^48).
	SET inStr TO inStr + CHAR(FLOOR((inSrtLength - s1)/ 2^48)).
	LOCAL s2 IS MOD(s1,2^32).
	SET inStr TO inStr + CHAR(FLOOR((s1 - s2)/ 2^32)).
	LOCAL s3 IS MOD(s2,2^16).
	SET inStr TO inStr + CHAR(FLOOR((s2 - s3)/ 2^16)).
	SET inStr TO inStr + CHAR(s3).
	
	LOCAL h0 IS h0Start.
	LOCAL h1 IS h1Start.
	LOCAL h2 IS h2Start.
	LOCAL h3 IS h3Start.
	LOCAL h4 IS h4Start.
	
	LOCAL wMax IS CHOOSE 16 IF reduced ELSE 80.
	LOCAL w0 IS wMax / 4.
	LOCAL w1 IS w0 * 2.
	LOCAL w3 IS w0 * 3.
	
	LOCAL iMax IS inStr:LENGTH - 1.
	FROM { local i IS 0. } UNTIL i > iMax STEP { SET i TO i + 32. } DO {
	
		LOCAL wordList IS LIST().
		LOCAL jMax IS i + 32.
		FROM { LOCAL j IS i. } UNTIL j >= jMax STEP { SET j TO j + 2. } DO {
			wordList:ADD(num_to_bin(UNCHAR(inStr[j]),16) + num_to_bin(UNCHAR(inStr[j + 1]),16)).
		}
		
		IF NOT reduced {
			FROM { LOCAL j IS 16. } UNTIL j >=80 STEP { SET j TO j + 1. } DO {
				LOCAL tmpWord IS bin_XOR(wordList[j - 3],wordList[j - 8]).
				SET tmpWord TO bin_XOR(tmpWord,wordList[j - 14]).
				SET tmpWord TO bin_XOR(tmpWord,wordList[j - 16]).
				SET tmpWord TO bin_rotate_left(tmpWord,1).
				wordList:ADD(tmpWord).
			}
		}
		
		LOCAL f IS "".
		LOCAL k IS "".
		LOCAL aSeg IS h0.
		LOCAL bSeg IS h1.
		LOCAL cSeg IS h2.
		LOCAL dSeg IS h3.
		LOCAL eSeg IS h4.
		LOCAL tmpSeg IS "".
		FROM { LOCAL w IS 0. } UNTIL w >= wMax STEP { SET w TO w + 1. } DO {
			IF w < w1 {
				IF w < w0 {
					//LOCAL bANDc IS bin_AND(bSeg,cSeg).
					//LOCAL NOTbANDd IS bin_AND(bin_NOT(bSeg),dSeg).
					//SET f TO bin_OR(bANDc,NOTbANDd).
					SET f TO bin_OR(bin_AND(bSeg,cSeg),bin_AND(bin_NOT(bSeg),dSeg)).
					SET k TO k0.
				} ELSE {
					//LOCAL bXORc IS bin_XOR(bSeg,cSeg).
					//SET f TO bin_XOR(bXORc,dSeg).
					SET f TO bin_XOR(bin_XOR(bSeg,cSeg),dSeg).
					SET k TO k1.
				}
			} ELSE {
				IF w < w3 {
					//LOCAL bANDc IS bin_AND(bSeg,cSeg).
					//LOCAL bANDd IS bin_AND(bSeg,dSeg).
					//LOCAL cANDd IS bin_AND(cSeg,dSeg).
					//SET f TO bin_OR(bin_OR(bANDc,bANDd),cANDd).
					SET f TO bin_OR(bin_OR(bin_AND(bSeg,cSeg),bin_AND(bSeg,dSeg)),bin_AND(cSeg,dSeg)).
					SET k TO k2.
				} ELSE {
					//LOCAL bXORc IS bin_XOR(bSeg,cSeg).
					//SET f TO bin_XOR(bXORc,dSeg).
					SET f TO bin_XOR(bin_XOR(bSeg,cSeg),dSeg).
					SET k TO k3.
				}
			}
			//SET tmpSeg TO bin_rotate_left(aSeg,5).
			//SET tmpSeg TO bin_ADD(tmpSeg,f).
			//SET tmpSeg TO bin_ADD(tmpSeg,eSeg).
			//SET tmpSeg TO bin_ADD(tmpSeg,k).
			//SET tmpSeg TO bin_ADD(tmpSeg,wordList[w]).
			SET tmpSeg TO bin_ADD(bin_ADD(bin_ADD(bin_ADD(bin_rotate_left(aSeg,5),f),eSeg),k),wordList[w]).
			SET eSeg TO dSeg.
			SET dSeg TO cSeg.
			SET cSeg TO bin_rotate_left(bSeg,30).
			SET bSeg TO aSeg.
			SET aSeg TO tmpSeg.
		}
		SET h0 TO bin_ADD(h0,aSeg).
		SET h1 TO bin_ADD(h1,bSeg).
		SET h2 TO bin_ADD(h2,cSeg).
		SET h3 TO bin_ADD(h3,dSeg).
		SET h4 TO bin_ADD(h4,eSeg).
	}
	RETURN compress(h0 + h1 + h2 + h3 + h4).
}

FUNCTION bin_rotate_left {
	PARAMETER binStr,rotate.
	RETURN binStr:SUBSTRING(rotate,binStr:LENGTH - rotate) + binStr:SUBSTRING(0,rotate).
}

FUNCTION bin_NOT {
	PARAMETER bin.
	LOCAL returnStr IS "".
	FROM { LOCAL i IS bin:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		SET returnStr TO (CHOOSE "1" IF (bin[i] = "0") ELSE "0") + returnStr.
		//IF bin[i] = "0" {
		//	SET returnStr TO "1" + returnStr.
		//} ELSE {
		//	SET returnStr TO "0" + returnStr.
		//}
	}
	RETURN returnStr.
}

FUNCTION bin_OR {
	PARAMETER bin1,bin2.
	LOCAL returnStr IS "".
	FROM { LOCAL i IS bin1:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		SET returnStr TO (CHOOSE "1" IF ((bin1[i] = "1") OR (bin2[i] = "1")) ELSE "0") + returnStr.
		//LOCAL aVal IS bin1[i] = "1".
		//LOCAL bVal IS bin2[i] = "1".
		//SET returnStr TO (CHOOSE "1" IF (aVal OR bVal) ELSE "0") + returnStr.
		//IF aVal OR bVal {
		//	SET returnStr TO "1" + returnStr.
		//} ELSE {
		//	SET returnStr TO "0" + returnStr.
		//}
	}
	RETURN returnStr.

}

FUNCTION bin_AND {
	PARAMETER bin1,bin2.
	LOCAL returnStr IS "".
	FROM { LOCAL i IS bin1:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		SET returnStr TO (CHOOSE "1" IF ((bin1[i] = "1") AND (bin2[i] = "1")) ELSE "0") + returnStr.
		//LOCAL aVal IS bin1[i] = "1".
		//LOCAL bVal IS bin2[i] = "1".
		//SET returnStr TO (CHOOSE "1" IF (aVal AND bVal) ELSE "0") + returnStr.
		//IF aVal AND bVal {
		//	SET returnStr TO "1" + returnStr.
		//} ELSE {
		//	SET returnStr TO "0" + returnStr.
		//}
	}
	RETURN returnStr.

}

FUNCTION bin_XOR {
	PARAMETER bin1,bin2.
	LOCAL returnStr IS "".
	FROM { LOCAL i IS bin1:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		SET returnStr TO (CHOOSE "1" IF ((bin1[i]:TONUMBER() + bin2[i]:TONUMBER()) = 1) ELSE "0") + returnStr.
		//LOCAL aVal IS bin1[i]:TONUMBER().
		//LOCAL bVal IS bin2[i]:TONUMBER().
		//IF aVal + bVal = 1 {
		//	SET returnStr TO "1" + returnStr.
		//} ELSE {
		//	SET returnStr TO "0" + returnStr.
		//}
		
		//SET returnStr TO (CHOOSE "1" IF (((bin1[i] = "1") AND (bin2[i] = "0")) OR ((bin1[i] = "0") AND (bin2[i] = "1"))) ELSE "0") + returnStr.
		//LOCAL aVal IS bin1[i] = "1".
		//LOCAL bVal IS bin2[i] = "1".
		//SET returnStr TO (CHOOSE "1" IF ((aVal AND (NOT bVal)) OR ((NOT aVal) AND bVal)) ELSE "0") + returnStr.
		//IF (aVal AND (NOT bVal)) OR ((NOT aVal) AND bVal) {
		//	SET returnStr TO "1" + returnStr.
		//} ELSE {
		//	SET returnStr TO "0" + returnStr.
		//}
	}
	RETURN returnStr.
}

FUNCTION bin_ADD {//add 2 bin strings, will discard any overflow, bin string must be same length
	PARAMETER bin1,bin2.
	LOCAL returnStr IS "".
	LOCAL carry IS 0.
	FROM { LOCAL i IS bin1:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		LOCAL sum IS bin1[i]:TONUMBER() + bin2[i]:TONUMBER() + carry.
		SET carry TO FLOOR(sum / 2).
		SET returnStr TO MOD(sum,2):TOSTRING + returnStr.
	}
	RETURN returnStr.
}

FUNCTION compress {//converts a bin string into usable characters for a file name
	PARAMETER bin.
	LOCAL bits IS 8.
	LOCAL offset IS 128.
	LOCAL returnStr IS "".
	LOCAL iMax IS bin:LENGTH - 1.
	FROM { LOCAL i IS 0. } UNTIL i > iMax STEP { SET i TO i + bits. } DO {
		LOCAL subBin IS bin:SUBSTRING(i,bits).
		SET returnStr TO returnStr + CHAR(bin_to_num(subBin) + offset).
	}
	RETURN returnStr.
}

FUNCTION num_to_bin {//converts a number to a binary string of a given length
	PARAMETER num,maxBits.
	LOCAL returnStr IS "".
	UNTIL returnStr:LENGTH >= maxBits {
		SET returnStr TO MOD(num,2) + returnStr.
		SET num TO FLOOR(num / 2).
	}
	RETURN returnStr.
}

FUNCTION bin_to_num {//converts a binary string to a number
	PARAMETER bin.
	LOCAL returnNum IS 0.
	//UNTIL bin:LENGTH = 0 {
	FROM { LOCAL i IS bin:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
		SET returnNum TO returnNum + (bin[i]:TONUMBER() * 2^(i)).
	}
	RETURN returnNum.
}