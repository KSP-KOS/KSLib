@lazyglobal off.
function terminal_dialog
{
  parameter
    prefix,
    suffix_list.

  clearscreen.

  print "ag7/ag8 - previous/next ag9 - enter ag10 - cancel" at(0, 2).

  local index is 0.
  local len is suffix_list:length.

  local old_previous is ag7.
  local old_next is ag8.
  local old_enter is ag9.
  local old_cancel is ag10.

  local done is false.
  until done
  {
    print prefix + suffix_list[index] + "                " at(0, 0).

    if old_previous <> ag7
    {
      set old_previous to ag7.
      set index to mod(index - 1, len).
    }
    if old_next <> ag8
    {
      set old_next to ag8.
      set index to mod(index + 1, len).
    }
    if old_enter <> ag9
    {
      set done to true.
    }
    if old_cancel <> ag10
    {
      set done to true.
      set index to -1.
    }
  }

  clearscreen.

  return index.
}
