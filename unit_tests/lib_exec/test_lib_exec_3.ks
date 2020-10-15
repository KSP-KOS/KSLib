// test_lib_exec_3.ks 
// Copyright © 2020 KSLib team 
// Lic. MIT

run lib_exec.
run lib_testing.

//testing for get_suffix and set_suffix

//checking get_suffix
assert(get_suffix(ship,"mass") = ship:mass).

//suffixes should work on the returned structure
assert(get_suffix(ship,"parts"):length = ship:parts:length).

//should be able to chain more than one get together
assert(get_suffix(get_suffix(ship,"parts"),"length") = ship:parts:length).

//checking the parameter passing for suffixes that are functions
local result is get_suffix(body,"geopositionlatlng",list(1,2)).
assert(result:lat = 1 AND result:lng = 2).

local result is get_suffix(body,"geopositionlatlng",list(3,4)).
assert(result:lat = 3 AND result:lng = 4).

set core:tag to "".

set_suffix(core,"tag","exec").
assert(get_suffix(core,"tag") = "exec").
set_suffix(core,"tag","test").
assert(get_suffix(core,"tag") = "test").

set core:tag to "".

//TODO: add get and set checks for lexicon

local testLex IS lexicon().

set_suffix(testLex,"one",1).
assert(testLex:haskey("one")).
assert(get_suffix(testLex,"one") = 1).


test_success().