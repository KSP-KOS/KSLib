// example_lib_list_dialog.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

run lib_list_dialog.
set numbers to list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9").
set options to list().
for i in numbers {
  for j in numbers {
    options:add(i + j).
  }
}
print "your first choice is: " + options[open_list_dialog("choose an option:", options)].
wait 2.
set choice to open_cancelable_list_dialog("choose an option:", options).
if choice = -1 {
  print "you canceled the dialog".
} else {
  print "your second choice is: " + options[choice].
}
