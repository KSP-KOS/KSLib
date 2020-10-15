// lib_raw_user_input.ks provides a low level library to do user input via action groups. I believe it supports AGX to.
// Copyright © 2015,2020 KSLib team 
// Lic. MIT
// Originally developed by abenkovskii
@LAZYGLOBAL OFF.

run lib_exec.

function wait_for_action_groups
{
  parameter ag_list. // list of strings

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
    if iter_a:atend or iter_b:atend
    {
      set result to -1.
    }
    return result.
  }

  local arg_string is "".
  local separator is "".

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
    wait 0.
  }

  return result.
}
