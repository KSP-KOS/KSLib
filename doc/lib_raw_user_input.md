// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_raw_user_input

A low level library to do user input via action groups.
I believe it supports AGX to.

dependencies:
  * lib_exec library

### wait_for_action_groups

args:
  * ag_list - list of numbers, a list of action group numbers to listen.

returns:
  * number, a number of action group pressed by user

description:
  * Wait until user activates one of the action groups from ag_list,

