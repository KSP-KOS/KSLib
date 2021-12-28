## unit_tests/lib_num_to_formatted_str

A `test_lib_num_to_formatted_str.ks` is a set of tests to verfy the basic functioanlity of the library.
As many edge cases as I could reasonably think up are covered but there might still be others out there.


### instructions:
* Copy all files from "unit_tests/lib_num_to_formatted_str/" and "library/lib_num_to_formatted_str.ks"
  to the archive ("<ksp_folder>/Ships/Script")
* Change the current working directory of the core to be the rood director of the archive
  (`CD("0:/")` or `SWITCH TO 0.`).
* Then run `test_lib_num_to_formatted_str.ks`

### what to expect:

If everything is fine then "all test passed" will be printed in the terminal.

Should however a test fail then an exception will be thrown for the given test.


---
Copyright © 2021 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).