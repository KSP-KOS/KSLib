// example_lib_raw_user_input.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT
run lib_raw_user_input.
local quit is false.
until quit
{
  clearscreen.
  print "main menu".
  print "3. submenu".
  print "4. quit".
  local menu_option is wait_for_action_groups(list("ag3", "ag4")).
  if menu_option = 1
  {
    set quit to true.
  }
  else if menu_option = 0
  {
    local sub_quit is false.
    until sub_quit
    {
      clearscreen.
      print "submenu".
      print "7. say hello".
      print "8. main menu".
      local menu_option is wait_for_action_groups(list("ag7", "ag8")).
      if menu_option = 0
      {
        print "hello".
        wait 1.
      }
      else if menu_option = 1
      {
        set sub_quit to true.
      }
    }
  }
}
