run q_terminal_shared.

list files in file_list.

local index is terminal_dialog("edit ", file_list).

if index >= 0
{
  edit file_list[index].
}
