// This file is distributed under the terms of the MIT license, (c) the KSLib team

// This is intended to be run as a boot script.

run lib_input_string.
run lib_file_exists.
run spec_char.

if not file_exists("acount.ksm") {
 set newuser to true.
} else {
 set newuser to false.
 run acount.ksm.
}
clearscreen.

print "+-----------------------------------------+" at (3,5).
print "|                                         |" at (3,6).
print "|     User:                               |" at (3,7).
print "|                                         |" at (3,8).
print "+-----------------------------------------+" at (3,9).
print "+-----------------------------------------+" at (3,12).
print "|                                         |" at (3,13).
print "| Password:                               |" at (3,14).
print "|                                         |" at (3,15).
print "+-----------------------------------------+" at (3,16).

If newuser {
 print "Welcome please create a new acount." at (5,3).
} else {
 print "Secure terminal:" at (2,2).
 print "Please enter your user name and password." at (2,3).
}
global username is input_string(24,12,7,false,true).
local password is input_string(24,12,14,true,false).

if not newuser {
 if user_check(username) = false or password_check(password) = false {
  Print "Username or Password incorect" at (5,18).
  wait 2.
  reboot.
 }
} else {
 log "" to acount.ks.
 delete acount.ks.
 log "@LAZYGLOBAL off." to acount.ks.
 log "function user_check { parameter user. return user = "+quote+username+quote+". }." to acount.ks.
 log "function password_check { parameter pass. return pass = "+quote+password+quote+". }." to acount.ks.
 compile acount.ks.
 delete acount.ks.
}
clearscreen.
print "welcome "+username.
