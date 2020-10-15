## lib_exec

This library is a powerful tool for unhardcoding program's behavior.
As far as I know it works fine in all possible special cases.

#### WARNINGS:
  * this library can fail if there is insufficient free space on the local volume.
  * this library requires several global variables to work. As a result, any scripts making use of this library should not use any of the following variable names: `_exec_idString` , `_evaluate_result` , `_exec__param_list` , `_past_exec_strings`

### execute

args:
  * command - a command or a sequence of commands to execute.
    example: "list files in f_list. print f_list[0].". Note:
    the command should end with `.` (dot).

description:
  * Execute a command.

example:
  `execute("set x to 42. print x.").`

caveat #1:
  * run command in the current version of kOS works in a weird way:
```
run foo.
delete foo.
rename bar to foo.
run foo.  // will still run the first version of foo
```
  * lib_exec can't fix it:
```
execute("run foo.").
delete foo.
rename bar to foo.
execute("run foo.").  // will still run the first version of foo
```
  * you'll have to change the name of file every time if you want it to be recompiled

caveat #2:
  * the command will be executed in the global scope. i.e. this won't work:
```
{
  local my_example_var is 42.
  execute("print my_example_var.").
}
```

caveat #3
  * The limit on the size of a command that can be executed is how much free space you have on the local volume of the core

##### The same caveats apply to other functions from this library.

### evaluate

args:
  * expression - string, an expression to evaluate. Unlike "command" parameter from function
    `execute` an expression should **not** end with dot: `evaluate("7 * a + 2").`.

returns:
  * result - result of expression evaluation.

description:
  * Evaluate an expression.

example:
  `print evaluate("x*x + x + 8").`

### evaluate_function

args:
  * function_name - string, a name of function to evaluate
  * parameter_list - list of anything, parameters to pass to the function

returns:
  * result - result of function evaluation.

example:
  `print evaluate_function("foo", list(42, true, "hello")).`
  does exactly the same as:
  `print foo(42, true, "hello").`

### get_suffix

args:
  * structure - any structure, the structure to get the suffix of
  * suffix - string, the suffix to get
  * parameter_list - list of anything, if a suffix is a function then this is the ordered list of parameters to be passed to the suffix 0th parameter maps to the 0th item in the list, will be ignored if not of type list, defaulted to `FALSE`

returns:
  * result - will be what ever the suffix returns

example:
```
print get_suffix(ship,"mass").
print get_suffix(body,"geopositionlatlng",list(1,2)).
```
  is equivalent to
```
print ship:mass.
print body:geopositionlatlng(1,2).
```

### set_suffix

args:
  * structure - any structure, the structure to set the suffix of
  * suffix - string, the suffix to set
  * val - any structure, the value to set the suffix to

example:
  `set_suffix(core,"tag","lib_exec").`
  is the same as
  `set core:tag to "lib_exec".


### useful tips

* Compilation is a slow process. Each call of lib_exec's functions causes
  a compilation. If you want to speed your main loop up try this technique:
  ```
  lock my_expr to 0.  // or kOS compiler won't threat my_expr as locked
  execute("lock my_expr to x*x + x + 8."). // insert your expression here
  set done to false.
  until done {
    print my_expr.  // insert your main loop code here
  }
  ```

---
Copyright © 2015,2019,2020 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).