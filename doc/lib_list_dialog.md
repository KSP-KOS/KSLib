## lib_list_dailog

This library helps when you want the user to choose a value from a long list.

Dependencies:
  * [lib_menu.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_menu.ks)

### open_list_dialog

args:
  * title - string, a title to display at the top of the dialog
  * option_list - list of strings, options from which the user will choose

returns:
  * number, an index of option chosen by user

description:
  Open a multi-page list dialog, return an index of option chosen by user.

controlled by action groups:
  * AG 7 - move up
  * AG 8 - move down
  * AG9 - select

### open_cancelable_list_dialog

args:
  * title - string, a title to display at the top of a dialog
  * option_list - list of strings, options from which the user will choose

returns:
  * number, an index of option chosen by user or -1 if "Cancel" was chosen

description:
  Open a multi-page list dialog, return an index of option chosen by user
  or -1 if the dialog was canceled.

### _list_dialog

description:
  This function is internal and should not be used outside of lib_list_dialog.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).