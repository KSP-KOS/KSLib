## lib_input_terminal.

`lib_input_terminal` provides functions for getting user entered strings or numbers though terminal inputs.

### terminal_input_string

args:
  1) col - (scalar), The column to start the print of the current string at as required by `PRINT x AT(col,row).`
  2) row - (scalar), The row to start the print of the current string at as required by `PRINT x AT(col,row).`
  3) maxLength - (scalar), The maximum length of the string that can be returned,
    defaulted to the terminal width minus the col argument.
  4) inValue - (string or scalar), The string or scalar to pre-populate the input space with,
    defaulted to an empty string.
  5) cursorBlink - (boolean), Determines if the character denoting where the next char entered by the user will go will cycle between `█` and `_` or stay a stedy `_`
    defaulted to true.
  
returns:
  A string
  
description:
  This function takes key presses on the kOS terminal and adds them into a single string until the user presses enter to stop and return the string.
  While the string is being added to it will be printed on the terminal at the location set by the arguments.
  The control keys that are recognized by this function are backspace, delete, and enter/return.
    Pressing enter/return ends the loop and returns the current string.
    Pressing backspace removes the last charter from the current string until the string is empty.
    Pressing delete sets the current string to an empty string.
	
### terminal_input_number

args:
  1) col - (scalar), The column to start the print of the current string at as required by `PRINT x AT(col,row).`
  2) row - (scalar), The row to start the print of the current string at as required by `PRINT x AT(col,row).`
  3) maxLength - (scalar), The one greater than the maximum length of the string that can be returned,
    defaulted to the terminal width minus the col argument.
  4) inValue - (string or scalar), The string or scalar to pre-populate the input space with,
    defaulted to an empty string.
    if not a valid number will be discarded and replaced with the default.
  5) cursorBlink - (boolean), Determines if the character denoting where the next char entered by the user will go will cycle between "█" and "_" or stay a steady "_"
    defaulted to true.
  
returns:
  A string

description:
  This function takes key presses on the kOS terminal and adds them into a single string for displaying a number.  As such this function only works with a limited set of keys. The keys it will add to the string are "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", and "." with "+" and "-" for denoting sign.
  While the string is being added to it will be printed on the terminal at the location set by the arguments.
  The function will also try to format the string so that it can be directly converted into a scalar by the `:TOSCALAR()` suffix. Should the formatting fail, " 0" is returned by default.
  There is only allowed to be one "." character in a string at a time. If a second "." is entered it will be ignored.
  The control keys that are recognized by this function are "+", "-", backspace, delete, and enter/return.
    Pressing "-" will change the first character of the string from "-" to " " or " " to "-".
    Pressing "+" will change the first character of the string from "-" to " " or will do nothing if the first character is already " ".
    Pressing backspace will remove the last character from the string until there is only one character left.
    Pressing delete will erase then currently stored string.
    Pressing enter/return will end the function and return the current string.

### input_loop

args:
  1) col - (scalar), The column to start the print of the current string at as required by `PRINT x AT(col,row).`
  2) row - (scalar), The row to start the print of the current string at as required by `PRINT x AT(col,row).`
  3) maxLength - (scalar), The one greater than the maximum length of the string that can be returned,
  4) minLength - (scalar), The smallest length that pressing backspace can reduce the string to.
  5) workingStr - (string), The string to pre-populate the input space with
  6) cursorBlink - (boolean), determines if the character denoting where the next char entered by the user will go will cycle between "█" and "_" or stay a steady "_"
  7) concatenator - (user delegate or anonymous function), a function with the rules for concatenation of the string.

returns:
  *A string

description:
  This function reads the key presses and stores the current string until the loop is ended by pressing enter.
  While the current string is being added to it will be printed on the terminal at the location set by the arguments.
  The concatenator function is called with the current string, non-control key presses, and maxLength.
    It is responsible for the rules of what a given key press will do to the current string and keeping the string from getting larger than maxLength.  It is expected to return the processed string back to `input_loop` - to be stored as the current string.
  The control keys that are recognized by this function are backspace, delete, and enter/return.
    Pressing enter/return ends the loop and returns the current string.
    Pressing backspace removes the last character from the current string until the string length is less than or equal to minLength
    Pressing delete sets the current string to an empty string.
  
---
Copyright © 2020 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).