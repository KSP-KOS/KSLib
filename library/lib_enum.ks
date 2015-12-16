// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

function enum_all {
  parameter a, assertFn.
  for i in a { if not assertFn:call(i) return false. }
  return true.
}

function enum_any {
  parameter a, assertFn.
  for i in a { if assertFn:call(i) return true. }
  return false.
}

function enum_count {
  parameter a, assertFn.
  local result is 0.
  for i in a { if assertFn:call(i) set result to result + 1. }
  return result.
}

function enum_each {
  parameter a, opFn.
  for i in a opFn:call(i).
}

function enum_each_slice {
  parameter a, n, opFn.
  from { local i is 0. } until i > a:length - 1 step { set i to i + n. } do {
    opFn:call(a:sublist(i, min(n, a:length - i))).
  }
}

function enum_each_with_index {
  parameter a, opFn.
  from { local i is 0. } until i > a:length - 1 step { set i to i + 1. } do {
    opFn:call(a[i], i + 1).
  }
}

function enum_find {
  parameter a, matchFn.
  for i in a { if matchFn:call(i) return i. }
  return false.
}

function enum_find_index {
  parameter a, matchFn.
  from { local i is 0. } until i > a:length - 1 step { set i to i + 1. } do {
    if matchFn:call(a[i]) return i.
  }
  return -1.
}

function enum_group_by {
  parameter a, opFn.
  local result is lexicon().
  for i in a {
    local val is opFn:call(i).
    if result:haskey(val) result[val]:add(i).
    else set result[val] to list(i).
  }
  return result.
}

function enum_map {
  parameter a, opFn.
  local result is list().
  for i in a result:add(opFn:call(i)).
  return result.
}

function enum_map_with_index {
  parameter a, opFn.
  local result is list().
  from { local i is 0. } until i > a:length - 1 step { set i to i + 1. } do {
    result:add(opFn:call(a[i], i + 1)).
  }
  return result.
}

function enum_max {
  parameter a. if a:length = 0 return false.
  local result is a[0].
  for i in a if i > result set result to i.
  return result.
}

function enum_min {
  parameter a. if a:length = 0 return false.
  local result is a[0].
  for i in a if i < result set result to i.
  return result.
}

function enum_partition {
  parameter a, matchFn.
  local result is list(list(), list()).
  for i in a {
    if matchFn:call(i) result[0]:add(i).
    else result[1]:add(i).
  }
  return result.
}

function enum_reduce {
  parameter a, memo, opFn.
  for i in a set memo to opFn:call(memo, i).
  return memo.
}

function enum_reject {
  parameter a, matchFn.
  local result is list().
  for i in a if not matchFn:call(i) result:add(i).
  return result.
}

function enum_reverse {
  parameter a.
  local result is list().
  from { local i is a:length - 1. } until i = -1 step { set i to i - 1. } do {
    result:add(a[i]).
  }
  return result.
}

function enum_select {
  parameter a, matchFn.
  local result is list().
  for i in a if matchFn:call(i) result:add(i).
  return result.
}

function enum_sort {
  parameter a, compareFn.

  function quicksort {
    parameter A, lo, hi.
    if lo < hi {
      local p is partition(A, lo, hi).
      quicksort(A, lo, p).
      quicksort(A, p + 1, hi).
    }
  }

  function partition {
    parameter A, lo, hi.
    local pivot is A[lo].
    local i is lo - 1.
    local j is hi + 1.
    until 0 {
      until 0 {
        set j to j - 1.
        if compareFn:call(A[j], pivot) <= 0 break.
      }
      until 0 {
        set i to i + 1.
        if compareFn:call(A[i], pivot) >= 0 break.
      }
      if i < j {
        local s is A[i].
        set A[i] to A[j].
        set A[j] to s.
      } else return j.
    }
  }

  local result is a:copy.
  quicksort(result, 0, a:length - 1).
  return result.
}
