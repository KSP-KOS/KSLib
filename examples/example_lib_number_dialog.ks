// example_lib_number_dialog.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

run lib_number_dialog.

set number to open_number_dialog("Apoapsis:",100000).
print "New apoapsis is: "+number.
