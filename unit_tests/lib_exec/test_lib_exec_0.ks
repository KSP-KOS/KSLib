// test_lib_exec_0.ks 
// Copyright © 2015,2019,2020 KSLib team 
// Lic. MIT

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

// checking evaluate_function

function sqr {
  parameter n.
  return n * n.
}

assert(evaluate_function("sqr",list(5)) = sqr(5)).
assert(evaluate_function("sqr",list(10)) = sqr(10)).

//checking recursion

function factorial_exec {
  parameter n.
  if n > 1 {
    return n * evaluate_function("factorial_exec",list(n - 1)).
  } else {
    return n.
  }
}

function factorial {
  parameter n.
  if n > 1 {
    return n * factorial(n - 1).
  } else {
    return n.
  }
}

assert(evaluate_function("factorial_exec",list(5)) = factorial(5)).

// case sensitivity check of the caching

execute("set s0 to " + char(34) + char(unchar("A")) + char(34) + ".").
set s1 to s0.
execute("set s0 to " + char(34) + char(unchar("a")) + char(34) + ".").
assert(unchar(s0) <> unchar(s1)).

// need to be able to run execute function many times thus this test checks you can.

global i is 0.
local y is 0.
until i >= 500 {//checks repetition of the same execution string,this may take time
  execute("set i to i + 1.").
  if y > 600 {
    break.
  } else {
    set y to y + 1.
  }
  assert(i = y).
}
assert(y = 500).

set i to 0.
set z to 0.

until i >= 500 {//checks repetition of unique execution strings
  if z >600 {
    break.
  } else {
    set z to z + 1.
  }
  execute("set i to " + z + ".").
  assert(i = z).
}

assert(z = 500).

if defined i { unset i. }
if defined y { unset y. }

// misc

assert(evaluate("ship:mass") = ship:mass).

test_success().