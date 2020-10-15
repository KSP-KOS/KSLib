// example_lib_seven_seg.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

run lib_seven_seg.

clearscreen.
Print "=======Mission Time=======" at (0,1).
print "==========================" at (0,6).
print "o" at (9,3).
print "o" at (9,4).
print "o" at (16,3).
print "o" at (16,4).
set timer to -59.
until false {
 if timer < 0 {
  seven_seg("-",0,2).
 } else {
  seven_seg("b",0,2).
 }
 set seconds to mod(abs(timer),60).
 seven_seg(mod(seconds/10,10),17,2).
 seven_seg(mod(seconds,10),20,2).
 set minutes to mod((abs(timer) - seconds)/60,60).
 seven_seg(mod(minutes/10,10),10,2).
 seven_seg(mod(minutes,10),13,2).
 set hours   to mod((abs(timer) - 60*minutes - seconds)/3600,3600).
 seven_seg(mod(hours/10,10),3,2).
 seven_seg(mod(hours,10),6,2).

 set timer to timer + 1.
 wait 1.
}

print "Launch" at (0,8).

