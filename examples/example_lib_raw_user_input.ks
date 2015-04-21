// This file is distributed under the terms of the MIT license, (c) the KSLib team
run lib_raw_user_input.
local quit is false.
until quit
{
  clearscreen.
  print "main menu".
  print "1. submenu".
  print "2. quit".
  local menu_option is wait_for_action_groups(list("ag1", "ag2")).
  if menu_option = "ag2"
  {
    set quit to true.
  }
  else if menu_option = "ag1"
  {
    local sub_quit is false.
    until sub_quit
    {
      clearscreen.
      print "submenu".
      print "1. say hello".
      print "2. main menu".
      local menu_option is wait_for_action_groups(list("ag1", "ag2")).
      if menu_option = "ag1"
      {
        print "hello".
        wait 1.
      }
      else if menu_option = "ag2"
      {
        set sub_quit to true.
      }
    }
  }
}
