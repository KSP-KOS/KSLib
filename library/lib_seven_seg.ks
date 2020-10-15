// lib_seven_seg.ks prints a seven segment display on the terminal showing the input value at the location specified.
// Copyright © 2015,2019 KSLib team 
// Lic. MIT
function seven_seg {
 parameter
  num,
  col,
  ln.
 if num:istype("scalar") {
  if num > -1 {
   if num < 5 {
    if num < 2 {
     if num < 1 {
      print  "_" at (col+1,ln).
      print "| |" at (col,ln+1).
      print "|_|" at (col,ln+2).
     } else {
      print  " " at (col+1,ln).
      print "  |" at (col,ln+1).
      print "  |" at (col,ln+2).
     }
    } else {
     if num < 4 {
      if num < 3 {
       print  "_" at (col+1,ln).
       print " _|" at (col,ln+1).
       print "|_ " at (col,ln+2).
      } else {
       print  "_" at (col+1,ln).
       print " _|" at (col,ln+1).
       print " _|" at (col,ln+2).
      }
     } else {
      print  " " at (col+1,ln).
      print "|_|" at (col,ln+1).
      print "  |" at (col,ln+2).
     }
    }
   } else {
    if num < 7 {
     if num < 6 {
      print  "_" at (col+1,ln).
      print "|_ " at (col,ln+1).
      print " _|" at (col,ln+2).
     } else {
      print  "_" at (col+1,ln).
      print "|_ " at (col,ln+1).
      print "|_|" at (col,ln+2).
     }
    } else {
     if num < 9 {
      if num < 8 {
       print  "_" at (col+1,ln).
       print "  |" at (col,ln+1).
       print "  |" at (col,ln+2).
      } else {
       print  "_" at (col+1,ln).
       print "|_|" at (col,ln+1).
       print "|_|" at (col,ln+2).
      }
     } else if num < 10 {
      print  "_" at (col+1,ln).
      print "|_|" at (col,ln+1).
      print "  |" at (col,ln+2).
     } else {
	  hudtext("ERROR: [lib_seven_seg.ks] number: " + num +" is out of bounds high" , 10, 2, 30, RED, FALSE).
	 }
    }
   }
  } else {
   hudtext("ERROR: [lib_seven_seg.ks] number: " + num +" is out of bounds low" , 10, 2, 30, RED, FALSE).
  }
 // special cases
 } else if num:ISTYPE("string") {
  if num = "b" {  //"b" = blank
   print  " " at (col+1,ln).
   print "   " at (col,ln+1).
   print "   " at (col,ln+2).
  } else if num = "-" { //"-" = minus
   print  " " at (col+1,ln).
   print " _ " at (col,ln+1).
   print "   " at (col,ln+2).
  } else {// else if num = // add more special cases here.
   hudtext("ERROR: [lib_seven_seg.ks] unrecognized string: " +num, 10, 2, 30, RED, FALSE).
  }
 } else {
  hudtext("ERROR: [lib_seven_seg.ks] unrecognized type: " +num:typename, 10, 2, 30, RED, FALSE).
 }
}
