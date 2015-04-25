@lazyglobal off.

run lib_exec.
run q_terminal_shared.

list files is file_list.

local index is terminal_dialog("run ", file_list).

if index > 0
{
  execute("run " + file_list[index] + ".").
}
