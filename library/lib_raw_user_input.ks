// This file is distributed under the terms of the MIT license, (c) the KSLib team
@LAZYGLOBAL OFF.

run lib_exec.

function wait_for_action_groups
{
  parameter ag_list.
  // I believe it's faster when executing each trigger manually
  local tmp_file_name is "wait_for_action_groups".
  for ag_number in ag_list
  {
    set tmp_file_name to tmp_file_name + "_" + ag_number.
  }
  set tmp_file_name to tmp_file_name + ".tmp".
  log "" to tmp_file_name.
  delete tmp_file_name.

  for ag_number in ag_list
    {
      log "set ag" + ag_number + " to false." to tmp_file_name.
    }
  for ag_number in ag_list
  {
    log
      "when _wait_for_ag__result <> -1 or ag" + ag_number + " then " +
        "if _wait_for_ag__result = -1 " +
          "set _wait_for_ag__result to " + ag_number + "."
    to tmp_file_name.
  }
  global _wait_for_ag__result is -1.
  execute("run " + tmp_file_name + ".").
  wait until _wait_for_ag__result <> -1.
  delete tmp_file_name.
  return _wait_for_ag__result.
}
