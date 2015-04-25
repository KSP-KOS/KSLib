run lib_ag_list_dialog.
local done is false.
local selected_file_index is 0.
until done
{
  list files in files.
  local dialog_output is list_dialog(
    "choose a file",
    files, selected_file_index,
    "1-up 2-down 3-options 0-exit",
    list("ag3", "ag10"), "ag1", "ag2"
  ).
  if dialog_output[0] = 1
  {
    set done to true.
  }
  else if dialog_output[0] = 0
  {
    set selected_file_index to dialog_output[1].
    local menu_option is menu_dialog(
      "file " + files[selected_file_index] + " options",
      list(list("ag1", "1. edit"), list("ag2", "2. run"), list("ag10", "0. cancel"))
    ).
    if menu_option <> 2 // edit or run
    {
      clearscreen.
      print "not implemented yet".
      wait 1.
    }
    else
    {
      print "debug 1".
    }
  }
}
clearscreen.
