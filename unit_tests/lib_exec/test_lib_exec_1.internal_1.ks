// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_exec.
run lib_testing.

function foo1
{
  return evaluate("42 * 2 / 2").
}

unset x.
execute("set x to 01234567.").
assert(x = 1234567).
execute("set x to 885.").
assert(x = 885).
