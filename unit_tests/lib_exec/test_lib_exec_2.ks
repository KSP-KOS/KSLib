// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_exec.
run lib_testing.

// importing (running) lib_exec from inside execute should work to

execute("run test_lib_exec_2.internal_1.").

assert(evaluate("true")).
assert(evaluate("24") = 24).
assert(evaluate("999" = 999)).

test_success().
