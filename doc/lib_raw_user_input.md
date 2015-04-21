// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_raw_user_input

A low level library to do user input via action groups.
I believe it supports AGX to.

dependencies:
  * lib_exec library

### wait_for_action_groups

args:
  * ag_list - list of strings, a list of action group names to listen.

returns:
  * number, an index of action group activated by user in ag_list.

description:
  * Wait until user activates one of the action groups from ag_list,
    return the name of the activated action group.
