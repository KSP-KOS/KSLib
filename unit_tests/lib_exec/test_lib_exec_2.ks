// test_lib_exec_2.ks 
// Copyright © 2015,2020 KSLib team 
// Lic. MIT

run lib_exec.
run lib_testing.

// importing (running) lib_exec from inside execute should work to

SET test_lib_exec_2_internal_ran TO FALSE.
execute("run test_lib_exec_2.internal_1.ks.").

assert(test_lib_exec_2_internal_ran).
assert(evaluate("true")).
assert(evaluate("24") = 24).
assert(evaluate("999" = 999)).

test_success().
