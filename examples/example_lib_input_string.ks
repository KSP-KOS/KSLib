// example_lib_input_string.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

// This is intended to be run as a boot script.

run lib_input_string.
local quote is char(34).

if not exists("account.ksm") {
 set newuser to true.
} else {
 set newuser to false.
 run account.ksm.
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
 print "Welcome please create a new account." at (5,3).
} else {
 print "Secure terminal:" at (2,2).
 print "Please enter your user name and password." at (2,3).
}
global username is input_string(24,12,7,false,true).
local password is input_string(24,12,14,true,false).

if not newuser {
 if user_check(username) = false or password_check(password) = false {
  Print "Username or Password incorrect" at (5,18).
  wait 2.
  reboot.
 }
} else {
 log " " to account.ks.
 deletepath("account.ks").
 log "@LAZYGLOBAL off." to account.ks.
 log "function user_check { parameter user. return user = "+quote+username+quote+". }." to account.ks.
 log "function password_check { parameter pass. return pass = "+quote+password+quote+". }." to account.ks.
 compile account.ks to account.ksm.
 deletepath("account.ks").
}
clearscreen.
print "welcome "+username.
