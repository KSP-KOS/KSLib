// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_exec.
run lib_testing.

// test if it works

IF DEFINED x { unset x. }
execute("set x to 42.").
assert(x = 42).

assert(evaluate("2 * 2 = 4")).


// lock command should work inside execute()
// the implementation that uses `run on` breaks here

lock f to 0. // for the compiler to realize that f is locked variable

execute("lock f to x * x.").

set x_list to list(-10, 40, 0, 1).

set x_iter to x_list:iterator.
until not x_iter:next
{
  set x to x_iter:value.
  assert(f = x * x).
}

execute("lock f to 1 / x.").

set x_list to list(-10, 40, -1, 1).

set x_iter to x_list:iterator.
until not x_iter:next
{
  set x to x_iter:value.
  assert(f = 1 / x).
}

// execute should work inside execute
// it looks a bit weird but imagine a situation where you execute
// a function that executes another function that executes something

IF DEFINED x { unset x. }

set cmd to "set x to -128.".
execute("execute(cmd).").
assert(x = -128).

function recursive
{
  parameter n.
  if n > 0
  {
    return evaluate("recursive(" + (n - 1) + ")").
  }
  else
  {
    return 8.
  }
}

assert(recursive(20) = 8).


set expr to "12 * 3".
assert(evaluate("evaluate(expr)") = (12 * 3)).

// need to be able to run execute function many times thus this test checks you can.

global i is 0.
local y is 0.
until i >= 500 {//this may take time
  execute("set i to i + 1.").
  if y > 3000 {
    break.
  } else {
    set y to y + 1.
  }
}
assert(i >= 500).
IF DEFINED i { unset i. }
IF DEFINED y { unset y. }

// misc

assert(evaluate("ship:mass") = ship:mass).

test_success().
