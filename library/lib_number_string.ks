// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

function numString {
 parameter
  number,  //input number
  ip,      //number of figues before the decimal point.
  dp.      //number of decimal places

 local string is "".
 local padder is "".
 local absNumber is abs(number).
 local index is ip-1.
 local firstNum is false.
 until firstNum or index = 0 { // stop adding spacers when the first number is found
  if mod(floor(absNumber/10^index),10) = 0 {
   set padder to padder +" ".
  }
  else {
   set firstNum to true.
  }
  set index to index-1.
 }.
 if dp = 0 {
  set string to string +round(absNumber).
 }.
 else {
//  set index to index-1.
  set string to string +floor(absNumber).
  set index to -1.
  set string to string +".".
  until index = -dp {
   set string to string +mod(floor(absNumber/10^index),10).
   set index to index-1.
  }.
  set string to string + mod(round(absNumber/10^index),10).
 }.
 if number < 0 {
  set string to padder +"-" +string.
 }
 else {
  set string to padder +" " +string.
 }.
 return string.
}.
