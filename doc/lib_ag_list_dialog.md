// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_ag_list_dialog

A high level library to make menus and lists selection dialogs.
The current uses action groups for user input.

dependencies:
  * lib_raw_user_input
    * lib_exec library

### menu_dialog

args:
  * title - string, will be displayed at top line of the dialog
  * options - list of list(string, string), each item element a menu
    option. option[0] is a name of action group assigned
    to this option. option[1] is a "display name"
    i.e. the sting your user will see on his screen.

returns:
  * number, index of the option chosen by user  (index in options list).

description:
  * Open a modal dialog with several options and return the index of the option
    that user chose.

### list_dialog

args:
  * title - string, will be displayed at top line of the dialog
  * element_list - list of strings, each string represents one element
  * selected_item - number, an index of an item selected by default
  * status_text - string, will be displayed at top line of the dialog
  * action_list - list strings, names of action groups assigned to specific
    actions that can be applied to the selected item.
  * ag_up - string, name of action group that moves the selection up by one line
  * ag_down - string, name of action group that moves the selection down by one line

returns:
  list(number, number). return_value[0] is an index of action a user chose
  (index in the action_list list). return_value[1] is an index of the list element
  chosen by a user (index in the element_list list).

description:
  * Open a modal dialog where a user can choose an element of the list and
    an action to apply to that element and return the both action and element index.
