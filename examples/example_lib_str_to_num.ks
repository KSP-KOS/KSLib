// example_lib_str_to_num.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

run lib_str_to_num.

local grav is ship:partsnamed("sensorGravimeter")[0].
local accelStr is grav:getmodule("ModuleEnviroSensor"):getfield("display").
local accel is str_to_num(accelStr:substring(0, accelStr:indexof("m/s^2"))).
print "acceleration due to gravity is " + accel + "m/s^2".
print "half that acceleration is " + (accel / 2) + "m/s^2".

print "str_to_num('5.23' + 'E+' + '24') * 2 = " + (str_to_num("5.23" + "E+" + "24") * 2).

print "Don't forget to check for NaN!".
local s is "".
from { local i is 0. } until i > 15 step { set i to i + 1. } do {
  set s to s + str_to_num("Batman").
}
print s + "Batman.".
