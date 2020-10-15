## lib_str_to_num

``lib_str_to_num.ks`` can be used to convert a stringified number back into a
legitimate number for use in computation. It can handle integers, floats, and
scientific notation.

### str_to_num

args:
  * The string that you want converted, as an integer ("12"), float ("1.23"), or in scientific notation ("5.2E+22").

returns:
  * number.
  * If the string is not a number, the function will return the string "NaN". Returning a falsey object is not possible, as `str_to_num("0") = FALSE` is true.

description:
  * This is intended for cases where operating with various modules, tags, or other data necessitates pulling out numeric information from a string. In conjunction with [string manipulation](http://ksp-kos.github.io/KOS_DOC/structures/misc/string.html) tools, you can extract the numeric component, and then use this function to convert to the number itself.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).