// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_num_to_str

``lib_num_to_str.ks`` can be used to to format a number in a string of constant length for use in a display.

### num_to_str

args:
  * The number that you want converted.
  * The max number of digits before the decimal point.
  * The number of digits to use after the decimal point.

returns:
  * string.
  
description:
  * This returns a string containing the number fed to it with the decimal point always in the same position in the string.
    so it can be printed at the same location in the terminal without having to worry about it moving as the number becomes larger or smaller. 
