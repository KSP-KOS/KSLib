## lib_input_string.

``lib_input_string.ks`` provides a method of inputting custom strings while a script is running via an on-screen keyboard.

### input_string

args:
  * Line   -``number`` value for the top edge of the keyboard
  * x0, y0 - ``number`` pair for where to display the input on screen
  * hidden - ``bool`` set to true to display "*" instead of character
  * help   - ``bool`` set to true to display help info info above the keyboard.
    * Note: this uses the 3 lines above the value given as the firs arg.

control:
  * Use the IJKL keys as arrow keys to move around the keyboard.
  * Use the H key to input the selected value and the N key to delete the previous value (backspace)
  
returns:
  * A string.
  
description:
  * This provides an on screen keyboard as a method of inputting user created strings while a script is running.
  Example use cases are:
    * Setting a file name for logging data to.
    * pop-up windows requesting docking passwords.
    * Used in conjunction with `lib_exec` as a script selector.
    * As part of a larger set of scripts to provide script writing in the terminal window.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).