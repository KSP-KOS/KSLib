// test_lib_exec_2.internal_1.ks 
// Copyright © 2015,2020 KSLib team 
// Lic. MIT

run lib_exec.
run lib_testing.

SET test_lib_exec_2_internal_ran TO TRUE.
assert(evaluate("true")).
assert(evaluate("1024") = 1024).
assert(evaluate("4096") = 4096).
