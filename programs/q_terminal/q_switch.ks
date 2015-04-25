@lazyglobal off.

run q_terminal_shared.

list volumes is volume_list.

local i is volume_list:length - 1.

unitl i < 0
{
  if volume_list[i]:name <> ""
  {
    volume_list[i] = volume_list[i]:name.
  }
  else
  {
    volume_list[i] = "" + i.
  }
}

local index is terminal_dialog("switch to ", volume_list).

if index > 0
{
  switch to index.
}
