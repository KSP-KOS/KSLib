// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_menu

Use this library when you want to display a menu on the screen.

### open_menu

args:
  * title - string, a title to display at the top of the dialog.
  * list_of_names - list of strings, options from which the user will choose.

returns:
  * string, an option chosen by user.

description:
  * Show a menu, return user's choice.
  * This should be preferred to open_menu_indexed when making a menu
    because strings as return values are more self-explanetory.

### open_menu_indexed

args:
  * title - string, a title to display at the top of the dialog.
  * list_of_names - list of strings, options from which the user will choose.

returns:
  * number, an index of option chosen by user.

description:
  * Identical to open_menu() but returns option index (an index in list_of_names list).
