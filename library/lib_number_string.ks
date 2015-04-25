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
 until index = 0 {
  if not firstNum {
   if mod(floor(absNumber/10^index),10) = 0 {
    set padder to padder +" ".               //adding spaces to the padder so that zeroes at the start are not displayed.
   } else {
    set string to string +mod(floor(absNumber/10^index),10).
    set firstNum to true.
   }
  }
  else {
   set string to string +mod(floor(absNumber/10^index),10).
  }.
  set index to index-1.
 }.
 if dp = 0 {
  set string to string +mod(round(absNumber/10^index),10).
 }.
 else {
  set string to string +mod(floor(absNumber/10^index),10).
  set index to index -1.
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
