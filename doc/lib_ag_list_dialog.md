// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_ag_list_dialog

A high level library to make menus and option lists.
The current uses action groups for user input.

dependencies:
  * lib_raw_user_input
    * lib_exec library

### menu_dialog

args:
  * title - string, a string to display on the top line of dialog
  * options - list of list(string, string), each item element a menu
    option. The first string of the element is a name of action group assigned
    to this option. The second string of the element is a "display name"
    i.e. the sting your user will see on his screen.

returns:
  * number, an index of the option chosen by user. It's a number of the option
    the options list.

description:
  * Show a modal dialog with several options and return the index of the option
    that user chose.

### list_dialog

to-do: documentation
