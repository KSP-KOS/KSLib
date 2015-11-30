// This file is distributed under the terms of the MIT license, (c) the KSLib team

##lib_get_type

``lib_get_type.ks`` can be used to infer the type of a variable,
differentiating between strings, numbers, lists, lexicons, stacks, queues, and
other kOS structs.

### get_type

args:
  * The variable whose type you want to infer, of any type.

returns:
  * string

description:
  * This is mainly intended to help make other functions more generalized, by allowing them to operate intuitively on single items, or collections of items. You can now design functions that call `get_type()` on their arguments, to determine how they should respond. You can also use `get_type()` to check the types of your arguments, allowing functions to return back an error message, rather than crashing the program.
