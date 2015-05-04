// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_list_dailog

This library helps when you want the user to choose a value from a long list.

### open_list_dialog

args:
  * title - string, a title to display at the top of a dialog
  * option_list - list of strings, options from which the user will choose

returns:
  * number, an index of option chosen by user

description:
  Open a multipage list dialog, return an index of option chosen by user

### open_cancelable_list_dialog

args:
  * title - string, a title to display at the top of a dialog
  * option_list - list of strings, options from which the user will choose

returns:
  * number, an index of option chosen by user or -1 if "Cancel" was chosen

description:
  Open a multipage list dialog, return an index of option chosen by user
  or -1 if the dialog was canceled.

### _list_dialog

description:
  this function is internal and should not be used outside lib_list_dialog