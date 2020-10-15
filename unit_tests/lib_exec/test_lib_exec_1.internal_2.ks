// test_lib_exec_1.internal_2.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

run lib_exec.
run lib_testing.

function foo2
{
  return evaluate("50 + 8").
}

IF DEFINED y { unset y. }
execute("set y to 64.").
assert(y = 64).
execute("set y to -102.").
assert(y = -102).
