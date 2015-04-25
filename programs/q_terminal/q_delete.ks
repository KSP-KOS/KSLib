run q_terminal_shared.

list files in file_list.

local index is terminal_dialog("delete ", file_list).

print index.

if index >= 0
{
  delete file_list[index].
}
