// lib_enum.ks provides a set of functions for manipulating lists, queues, and stacks using the new delegates syntax introduced in kOS version 0.19.0.
// Copyright © 2015,2016 KSLib team 
// Lic. MIT

{global Enum is lex(
"version", "0.1.1",
"all", all@,
"any", any@,
"count", count@,
"each", each@,
"each_slice", each_slice@,
"each_with_index", each_with_index@,
"find", find@,
"find_index", find_index@,
"group_by", group_by@,
"map", map@,
"map_with_index", map_with_index@,
"max", _max@,
"min", _min@,
"partition", partition@,
"reduce", reduce@,
"reject", reject@,
"reverse", reverse@,
"select", select@,
"sort", sort@
).

local y is true. local n is false.

function cast{
  parameter a,b,r is 0.
  if a:typename=b return a.
  if b="List"{set r to list(). for i in a r:add(i). return r.}
  if b="Queue"{set r to queue(). for i in a r:push(i). return r.}
  if b="Stack"{
    local l is stack().
    set r to stack(). for i in a r:push(i).
    for i in r l:push(i). return l.}}

function to_l{parameter c. return cast(c,"List").}

function all{parameter l,c. for i in l if not c(i) return n. return y.}

function any{parameter l,c. for i in l if c(i) return y. return n.}

function count{
  parameter l,c,r is 0. for i in l if c(i) set r to r+1. return r.}

function each{parameter l,o. for i in l o(i).}

function each_slice{
  parameter l,m,o,c is to_l(l),i is 0.
  until i > c:length-1 {
    o(cast(c:sublist(i,min(m,c:length-1)),l:typename)). set i to i+m.}}

function each_with_index{
  parameter l,o,i is 0. for j in to_l(l) {o(j,i+1). set i to i+1.}}

function find{parameter l,c. for i in l if c(i) return i. return n.}

function find_index{
  parameter l,c,i is 0. for j in to_l(l) {if c(j) return i. set i to i+1.}
  return -1.}

function group_by{parameter l,t,r is lex(). for i in l{
  local u is t(i). if r:haskey(u) r[u]:add(i). else set r[u] to list(i).}
  for k in r:keys set r[k] to cast(r[k],l:typename). return r.}

function map{
  parameter l,t,r is list(). for i in to_l(l) r:add(t(i)).
  return cast(r,l:typename).}

function map_with_index{parameter l,t,r is list(), i is 0, c is to_l(l).
  until i=c:length { r:add(t(c[i],i+1)). set i to i+1. }
  return cast(r,l:typename).}

function _max{parameter l,c is to_l(l). if c:length=0 return n.
  local r is c[0]. for i in c if i>r set r to i. return r.}

function _min{parameter l, c is to_l(l). if c:length=0 return n.
  local r is c[0]. for i in c if i<r set r to i. return r.}

function partition{parameter l,o,c is to_l(l), r is list(list(),list()).
  for i in c { if o(i) r[0]:add(i). else r[1]:add(i). }
  set r[0] to cast(r[0],l:typename). set r[1] to cast(r[1],l:typename).
  return r.
}

function reduce{parameter l,m,t. for i in to_l(l) set m to t(m,i). return m.}

function reject{parameter l,c,r is list().
  for i in to_l(l) if not c(i) r:add(i). return cast(r,l:typename). }

function reverse{parameter l,r is stack().
  for i in l r:push(i). return cast(r,l:typename).}

function select{parameter l,c,r is list().
  for i in to_l(l) if c(i) r:add(i). return cast(r,l:typename).}

function sort{
  parameter l,c,r is to_l(l):copy.
  function qs{parameter A,lo,hi.
    if lo<hi{local p is pt(A, lo, hi). qs(A, lo, p). qs(A, p + 1, hi).}}
  function pt{parameter A, lo, hi, pivot is A[lo], i is lo-1, j is hi+1.
    until 0 {
      until 0 {set j to j-1. if c(A[j],pivot)<=0 break.}
      until 0 {set i to i+1. if c(A[i],pivot)>=0 break.}
      if i<j{local s is A[i]. set A[i] to A[j]. set A[j] to s.} else return j.
    }
  }
  qs(r,0,r:length-1). return cast(r,l:typename).
}}
