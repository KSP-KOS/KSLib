run q_terminal_shared.

list volumes in volume_list.

local i is volume_list:length - 1.

until i < 0
{
  if volume_list[i]:name <> ""
  {
    set volume_list[i] to volume_list[i]:name.
  }
  else
  {
    set volume_list[i] to "" + i.
  }
  set i to i - 1.
}

local index is terminal_dialog("switch to ", volume_list).

if index >= 0
{
  switch to index.
}
