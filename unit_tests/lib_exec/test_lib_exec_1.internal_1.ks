// test_lib_exec_1.internal_1.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

run lib_exec.
run lib_testing.

function foo1
{
  return evaluate("42 * 2 / 2").
}

IF DEFINED x { unset x. }
execute("set x to 01234567.").
assert(x = 1234567).
execute("set x to 885.").
assert(x = 885).
