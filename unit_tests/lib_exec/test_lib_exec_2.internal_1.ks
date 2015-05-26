// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_exec.
run lib_testing.

assert(evaluate("true")).
assert(evaluate("1024") = 1024).
assert(evaluate("4096") = 4096).
