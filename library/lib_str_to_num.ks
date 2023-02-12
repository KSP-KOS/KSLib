// lib_str_to_num.ks can be used to convert a stringified number back into a legitimate number for use in computation.
// Copyright © 2015,2023 KSLib team 
// Lic. MIT
@LAZYGLOBAL off.
@CLOBBERBUILTINS off.

local num_lex   is lexicon().

num_lex:add("0", 0).
num_lex:add("1", 1).
num_lex:add("2", 2).
num_lex:add("3", 3).
num_lex:add("4", 4).
num_lex:add("5", 5).
num_lex:add("6", 6).
num_lex:add("7", 7).
num_lex:add("8", 8).
num_lex:add("9", 9).

function str_to_num {
  parameter s.

  // Handle negative numbers
  if s:startswith("-") {
    return str_to_num(s:substring(1,s:length-1)) * -1.
  }

  // Scientific Notation
  local e is s:find("e").
  if e <> -1 {
    local m is s:substring(e+1,1).
    if m <> "+" and m <> "-" { return "NaN". }
    local p is s:split("e" + m).
    if p:length <> 2 { return "NaN". }
    local p0 is str_to_num(p[0]).
    local p1 is str_to_num(p[1]).
    if p0 = "NaN" or p1 = "NaN" { return "NaN". }
    if m = "+" {
      return p0 * 10^p1.
    } else {
      return (p0 / 10^p1).
    }
  }

  // Decimals
  if s:contains(".") {
    local p is s:split(".").
    if p:length <> 2 { return "NaN". }
    local p0 is str_to_num(p[0]).
    local p1 is str_to_num(p[1]).
    if p0 = "NaN" or p1 = "NaN" { return "NaN". }
    return p0 + (p1 / (10^p[1]:length)).
  }

  // Integers (match on tokens, and bit-shift)
  local val is 0.
  for i IN s:split(""):sublist(1,s:length) {
    if num_lex:haskey(i) { set val to val + num_lex[i]. } else { return "NaN". }
    set val TO val * 10.
  }
  return val / 10.

}
