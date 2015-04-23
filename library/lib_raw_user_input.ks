// This file is distributed under the terms of the MIT license, (c) the KSLib team
// Originally developed by abenkovskii
@LAZYGLOBAL OFF.

run lib_exec.

function wait_for_action_groups
{
  parameter ag_list.
  // I believe it's faster when executing each trigger manually
  local tmp_file_name is "wait_for_action_groups".
  for ag_name in ag_list
  {
    set tmp_file_name to tmp_file_name + "_" + ag_name.
  }
  set tmp_file_name to tmp_file_name + ".tmp".
  log "" to tmp_file_name.
  delete tmp_file_name.

  for ag_name in ag_list
  {
    log "set " + ag_name + " to false." to tmp_file_name.
  }
  local ag_iter is ag_list:iterator.
  until not ag_iter:next
  {
    log
      "when _wait_for_ag__ag_index <> -1 or " + ag_iter:value + " then " +
        "if _wait_for_ag__ag_index = -1 " +
          "set _wait_for_ag__ag_index to " + ag_iter:index + "."
    to tmp_file_name.
  }
  global _wait_for_ag__ag_index is -1.
  execute("run " + tmp_file_name + ".").
  wait until _wait_for_ag__ag_index <> -1.
  delete tmp_file_name.
  return _wait_for_ag__ag_index.
}
