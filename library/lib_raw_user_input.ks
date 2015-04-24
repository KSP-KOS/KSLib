// This file is distributed under the terms of the MIT license, (c) the KSLib team
// Originally developed by abenkovskii
@LAZYGLOBAL OFF.

run lib_exec.

// function wait_for_action_groups
// {
//   parameter ag_list.
//   // I believe it's faster when executing each trigger manually
//   local tmp_file_name is "wait_for_action_groups".
//   for ag_name in ag_list
//   {
//     set tmp_file_name to tmp_file_name + "_" + ag_name.
//   }
//   set tmp_file_name to tmp_file_name + ".tmp".
//   log "" to tmp_file_name.
//   delete tmp_file_name.
//
//   for ag_name in ag_list
//   {
//     log "set " + ag_name + " to false." to tmp_file_name.
//   }
//   local ag_iter is ag_list:iterator.
//   until not ag_iter:next
//   {
//     log
//       "when _wait_for_ag__ag_index <> -1 or " + ag_iter:value + " then " +
//         "if _wait_for_ag__ag_index = -1 " +
//           "set _wait_for_ag__ag_index to " + ag_iter:index + "."
//     to tmp_file_name.
//   }
//   global _wait_for_ag__ag_index is -1.
//   execute("run " + tmp_file_name + ".").
//   wait until _wait_for_ag__ag_index <> -1.
//   delete tmp_file_name.
//   return _wait_for_ag__ag_index.
// }

function first_diff
{
  parameter list_a.
  parameter list_b.

  local iter_a is list_a:iterator.
  local iter_b is list_b:iterator.

  until not (iter_a:next and iter_b:next)
  {
    if iter_a:value <> iter_b:value
    {
      break.
    }
  }
  local result is iter_a:index.
  if iter_a:atend and iter_b:atend
  {
    set result to -1.
  }
  return result.
}

function wait_for_action_groups
{
  parameter ag_list. // list of strings

  local arg_string is "".
  local  is "".

  for ag_name in ag_list
  {
    set arg_string to arg_string + separator + ag_name.
    set separator to ", ".
  }

  lock _raw_input_ag_list to -1.
  execute("lock _raw_input_ag_list to list(" + arg_string + ").").
  local old_values is _raw_input_ag_list.

  local result is -1.
  until result <> -1
  {
    set result to first_diff(old_values, _raw_input_ag_list).
  }

  return result.
}
