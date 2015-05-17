// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_exec

This library is a powerful tool for unhardcoding program's behavior.
As far as I know it works fine in all possible special cases.

### execute

args:
  * command - a command or a sequence of commands to execute.
    example: "list files in f_list. print f_list[0].". Note:
    the command should end with `.` (dot).

description:
  * Execute a command.

example:
  `execute("set x to 42. print x.").`
  
caveat:
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


### evaluate

args:
  * expression - an expression to evaluate. Unlike "command" parameter from function
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
  * parameter_list - list, parameters to pass to the function. Each element's
    string representation should be a valid expression.
    e.g.: `evaluate_function("foo", list("abc", list(1, 2, 3)))` won't work.
    Use `evaluate_function("foo", list("abc", "list(1, 2, 3)"))` instead.

returns:
  * result - result of function evaluation.

example:
  `print evaluate_function("foo", list(42, true, "hello")).`
  does exactly the same as:
  `print foo(42, true, "hello").`

### useful tips

* Compilation is a slow process. Each call of lib_exec's functions causes
  a compilation. If you want to speed your main loop up try this techinque:
  ```
  lock my_expr to 0.  // or kOS compiler won't threat my_expr as locked
  execute("lock my_expr to x*x + x + 8."). // insert your expression here
  set done to false.
  until done {
    print my_expr.  // insert your main loop code here
  }
  ```

* If for some weird reason you don't want to use this library, a simple mediator
  helps in some simple cases (but fails in others):

  mediator.ks:
  ```
  run foo.
  ```
  main.ks:
  ```
  run mediator.
  delete foo.
  rename bar to foo.
  run mediator.  // actually runs the second version
  ```

  P.S. If the "mediator" above doesn't work for you, don't ask me why, just use
  lib_exec.
