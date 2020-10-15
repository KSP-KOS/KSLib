// test_lib_exec_1.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

run lib_testing.

// importing lib_exec multiple times should be safe

// imagine internal_1 and internal_2 are two libraries that both use lib_exec
run test_lib_exec_1.internal_1.ks.
assert(evaluate("true")).
run test_lib_exec_1.internal_2.ks.

assert(foo1() = 42).
assert(evaluate("true")).
assert(foo2() = 58).
assert(evaluate("230") = 230).

run lib_exec.

IF DEFINED z { unset z. }
execute("set z to 640 * 480.").
assert(z = 640 * 480).
assert(evaluate("435") = 435).

test_success().
